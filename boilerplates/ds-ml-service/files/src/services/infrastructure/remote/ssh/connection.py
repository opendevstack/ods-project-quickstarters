import logging
import os
import sys
from typing import Optional

import invoke
from fabric import Connection

from services.infrastructure import git_info
from services.infrastructure.environment import dsi_package, http_proxy, https_proxy, nexus_env
from services.infrastructure.git_info import GIT_COMMIT
from services.infrastructure.remote.ssh.exceptions import RemoteExecutionException


class SSHConnection(object):

    def __init__(self, host: str, username: str, password: str, port: int = 22, debug_mode: bool = False):
        self._logger = logging.getLogger(__name__)
        self._debug_mode = debug_mode
        self._connection: Connection = Connection(host=host,
                                                  user=username,
                                                  port=port,
                                                  connect_kwargs={
                                                      "password": password
                                                  })

        self._environment_name = "{0}-{1}".format(git_info.GIT_REPO_NAME, git_info.GIT_BRANCH.replace("/", "-"))
        self._env: Optional[dict] = None

    def _copy_resources(self):

        self._target_folder = "{0}/{1}".format(self._home_folder, self._environment_name)

        self._logger.info(
            "Copying package '{1}' to '{0}' on host...".format(self._target_folder, dsi_package()))

        self._check_exit_code(error_message="Creation and cleanup of target folder failed",
                              result=self._connection.run(
                                  command="""
if [ -d {0} ];
    then rm -r {0} 
fi
mkdir {0}""".strip().format(self._target_folder),
                                  hide=not self._debug_mode, warn=True))
        self._connection.put(dsi_package(), self._target_folder)
        self._connection.inline_ssh_env = True
        self._check_exit_code(error_message="Unpacking failed",
                              result=self._connection.run(
                                  command="tar zxf {0}/{1} -C {0}".format(self._target_folder,
                                                                          os.path.basename(
                                                                              dsi_package())),
                                  hide=not self._debug_mode,
                                  warn=True))

        self._logger.info("Copying package to '{0}' on host... Done!".format(self._target_folder))

    def run_training(self):

        train_script = """
import os
from common.logging import initialize_logging
from training.train import status, train
os.chdir(\\"{0}/{1}\\")
initialize_logging(remote=True)
train()""".strip().format(self._home_folder, self._environment_name)

        result = self._connection.run(
            command=self._create_run_script(train_script),
            hide=not self._debug_mode,
            warn=True,
            env=self.env())

        self._check_exit_code(error_message="Training Failed!", result=result)

        for line in result.stderr.strip().splitlines():
            self._logger.info(line)

    def save_model_locally(self):
        model_file = "{0}/{1}/{2}.model".format(self._home_folder, self._environment_name, GIT_COMMIT)
        self._logger.info("Downloading the model from {0}...".format(model_file))
        self._connection.get(model_file, "/app/{0}".format(os.path.basename(model_file)))
        self._logger.info("Downloading the model from {0}... Done!".format(model_file))

    def setup_prerequisites(self):

        self._logger.info("Checking pre requisites...")

        self._check_connection()
        self._copy_resources()

        self._logger.info("Checking for conda instalation...")

        conda_result: invoke.Result = self._connection.run(command="{0} --version".format(self._conda_executable),
                                                           hide=not self._debug_mode,
                                                           warn=True,
                                                           env=self.env())

        if conda_result.exited == 0:
            self._logger.info("Checking for conda instalation... Found!")
        else:
            self._logger.info("Checking for conda instalation... Not Found!")
            self._install_miniconda()

        self._logger.info("Checking for conda environment...")

        conda_result: invoke.Result = self._connection.run(
            command="source {0}/miniconda/bin/activate {1}".format(self._home_folder, self._environment_name),
            hide=not self._debug_mode,
            warn=True,
            env=self.env())

        if conda_result.exited == 0:
            self._logger.info("Checking for conda environment... Found!")
        else:
            self._logger.info("Checking for conda environment... Not Found!")
            self._create_conda_environment()

        self._update_pip()

        self._logger.info("Checking pre requisites... Done")
        self._logger.info("Ready to start the python scripts!!!")

    def _update_pip(self):

        nexus_url, nexus_username, nexus_password = nexus_env()

        if nexus_url and nexus_username and nexus_password:
            pip_command = "pip install -i https://{0}:{1}@{2}/repository/pypi-all/simple -r".format(nexus_username,
                                                                                                    nexus_password,
                                                                                                    nexus_url[8:])
        else:
            pip_command = "pip install -r"

        self._logger.info("Updating pip packages...")
        activate = "source {0}/miniconda/bin/activate {1}".format(self._home_folder, self._environment_name)
        requirements = " {0}/{1}/requirements.txt".format(self._home_folder, self._environment_name)
        deactivate = "source {0}/miniconda/bin/deactivate".format(self._home_folder)
        self._check_exit_code(error_message="Updating pip packages... Failed!",
                              result=self._connection.run(
                                  command="{0} && "
                                          "{1} {2} && "
                                          "{3}".format(activate,
                                                       pip_command,
                                                       requirements,
                                                       deactivate),
                                  hide=not self._debug_mode,
                                  warn=True,
                                  env=self.env()))

        self._logger.info("Updating pip packages... Done!")

    def _create_conda_environment(self):
        self._logger.info("Creating conda environment '{0}'...".format(self._environment_name))
        self._check_exit_code(error_message="Conda environment was not created!".format(self._environment_name),
                              result=self._connection.run(
                                  command="{0} create --yes --name {1} python={2}.{3}".format(self._conda_executable,
                                                                                              self._environment_name,
                                                                                              sys.version_info.major,
                                                                                              sys.version_info.minor),
                                  hide=not self._debug_mode,
                                  warn=True,
                                  replace_env=True,
                                  env=self.env()))

        self._logger.info("Creating conda environment '{0}'... Done!".format(self._environment_name))

    def env(self, reload=False) -> dict:
        if reload or not self._env:
            env = {}

            http_proxy_val = http_proxy()
            https_proxy_val = https_proxy()
            if http_proxy_val:
                env.update({"http_proxy": "{0}".format(http_proxy_val)})
            if https_proxy_val:
                env.update({"https_proxy": "{0}".format(https_proxy_val)})

            self._env = env

        return self._env

    def _install_miniconda(self) -> bool:
        miniconda_path = os.getenv("DSI_MINICONDA_PACKAGE_PATH")
        target_miniconda_path = "{0}/{1}".format(self._target_folder, os.path.basename(miniconda_path))

        self._logger.info("Installing conda...")

        self._check_exit_code(error_message="Conda installation failed!",
                              result=self._connection.run(
                                  command="bash {0} -b -p $HOME/miniconda".format(target_miniconda_path),
                                  hide=not self._debug_mode,
                                  warn=True))

        self._logger.info("Installing conda... Done!")

        return True

    def _check_exit_code(self, error_message: str, result: invoke.Result):
        if result.exited:
            self._logger.error(error_message)
            raise RemoteExecutionException(error_message, result)

    def _create_run_script(self, script):

        activate = "source {0}/miniconda/bin/activate {1}".format(self._home_folder, self._environment_name)
        deactivate = "source {0}/miniconda/bin/deactivate".format(self._home_folder)

        return "{1} && " \
               '{0} python -c "{2}" && ' \
               "{3}".format(self._python_path, activate, script, deactivate)

    def _check_connection(self):
        self._logger.info("Checking connection...")
        self._check_exit_code(error_message="Checking connection... Failed!",
                              result=self._connection.run(
                                  command="uname -a",
                                  hide=not self._debug_mode,
                                  warn=True))

        result: invoke.Result = self._connection.run(
            command="echo $HOME",
            hide=not self._debug_mode,
            warn=True)

        self._home_folder = result.stdout.strip()

        if not self._home_folder:
            raise RemoteExecutionException("Invalid Home Folder in the target host", result)

        self._conda_executable = "{0}/miniconda/bin/conda".format(self._home_folder)
        self._python_path = "PYTHONPATH=$PYTHONPATH:{0}/{1}".format(self._home_folder, self._environment_name)

        self._logger.info("Checking connection... Done!")

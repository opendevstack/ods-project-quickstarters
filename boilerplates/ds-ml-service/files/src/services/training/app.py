#!/usr/bin/env python
import argparse
import io
import logging
import os
import traceback

from flask import jsonify, send_file
from flask.templating import render_template

from model.train import train
from services.infrastructure.environment import debug_mode, execution_environment, DSI_EXECUTE_ON_LOCAL, \
    DSI_EXECUTE_ON_SSH, ssh_host, \
    ssh_username, ssh_password, ssh_port, DSI_EXECUTE_ON, training_auth
from services.infrastructure.flask import init_flask, status
from services.infrastructure.git_info import GIT_COMMIT, GIT_COMMIT_SHORT, GIT_BRANCH, GIT_LAST_CHANGE, GIT_REPO_NAME
from services.infrastructure.logging import initialize_logging
from services.infrastructure.remote.ssh.connection import SSHConnection

# Init flask application
TRAINING_KEY = '_training-job-key_'
training_args = None

_app, _executor, _auth = init_flask()
users = None

@_auth.get_password
def get_pw(username):
    global users

    users = training_auth()
    if username in users:
        return users.get(username)
    return None


@_executor.job
@_auth.login_required
def start_training():
    logging.getLogger(__name__).info("Training execution started...")
    # noinspection PyBroadException
    try:
        environemnt = execution_environment()
        if environemnt == DSI_EXECUTE_ON_LOCAL:
            train()
        elif environemnt == DSI_EXECUTE_ON_SSH:
            connection = SSHConnection(host=ssh_host(),
                                       username=ssh_username(),
                                       password=ssh_password(),
                                       debug_mode=debug_mode() or flask_args.debug,
                                       port=ssh_port())

            connection.setup_prerequisites()
            connection.run_training()
            connection.save_model_locally()
        else:
            raise Exception("{0} has a unknown value '{1}'".format(DSI_EXECUTE_ON, environemnt))

        logging.getLogger(__name__).info("Training execution ended!!!")
    except Exception:
        logging.getLogger(__name__).info("Training execution raised an exception...")
        f = io.StringIO()
        traceback.print_exc(file=f)
        f.seek(0)
        logging.getLogger(__name__).error(f.read())
    finally:
        _executor.futures.pop(TRAINING_KEY)


@_app.route('/')
@_auth.login_required
def get_status():
    return render_template('index.html',
                           git={
                               'commit': GIT_COMMIT,
                               'commit_short': GIT_COMMIT_SHORT,
                               'branch': GIT_BRANCH,
                               'last_change': GIT_LAST_CHANGE,
                               'name': GIT_REPO_NAME
                           },
                           training_args=vars(training_args) if training_args else {},
                           status=status())


@_app.route('/getmodel', methods=['GET'])
@_auth.login_required
def get_model():
    if _executor.futures.running(TRAINING_KEY):
        return jsonify({'error': "Model is not ready"}), 404

    model_path = "{0}.model".format(GIT_COMMIT)
    if os.path.exists(model_path):
        file = open(model_path, 'rb')
        return send_file(filename_or_fp=file,
                         mimetype="octet-stream",
                         attachment_filename=model_path,
                         as_attachment=True)
    else:
        return jsonify({'error': "Model could not be found"}), 404


def response(queued: bool, _status=None):
    return jsonify({
        'queued': queued,
        'running': _executor.futures.running(TRAINING_KEY),
        'status': _status
    })


@_app.route('/start', methods=['GET'])
@_auth.login_required
def start():
    if _executor.futures.running(TRAINING_KEY):
        return jsonify({'error': 'There is a training job already running'}), 400

    start_training.submit_stored(TRAINING_KEY)
    return response(queued=True), 202


@_app.route('/finished', methods=['GET'])
@_auth.login_required
def finished():
    if _executor.futures.running(TRAINING_KEY):
        return jsonify({'finished': False})
    else:
        return jsonify({'finished': True})


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Traning model and saving it")
    parser.add_argument("--port", "-p", required=False, default=8080, type=int, help="Port number for the Flask server")
    parser.add_argument("--debug", "-d", action="store_true", help="Enables debug mode in the Flask server")

    flask_args = parser.parse_args()

    initialize_logging("training.log", flask_args.debug)
    _app.run('0.0.0.0', flask_args.port, debug=debug_mode() or flask_args.debug)

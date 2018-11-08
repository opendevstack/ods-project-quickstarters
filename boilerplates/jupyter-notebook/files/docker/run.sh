#!/bin/bash
if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

# create jupyter directories
mkdir -p /opt/app-root/src/share/jupyter
mkdir -p /opt/app-root/src/share/jupyter/runtime
mkdir -p /opt/app-root/src/work/storage

# set the home directories to a folder with read/write access
export XDG_DATA_HOME=/opt/app-root
export HOME=/opt/app-root

# link jupyter configs
export JUPYTER_CONFIG_DIR=/opt/app-root/src/.jupyter
export JUPYTER_PATH=/opt/app-root/src/share/jupyter
export JUPYTER_RUNTIME_DIR=/opt/app-root/src/share/jupyter/runtime

source /opt/app-root/bin/activate

# install pip requirements
pip install -i https://$NEXUS_USERNAME:$NEXUS_PASSWORD@${NEXUS_URL:8}/repository/pypi-all/simple -r requirements.txt

exec jupyter lab

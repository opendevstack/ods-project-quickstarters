#!/bin/bash
if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

# create directory
mkdir -p /app/src/work/storage

# set the home directories to a folder with read/write access
export XDG_DATA_HOME=/app
export HOME=/app

# link jupyter configs
export JUPYTER_CONFIG_DIR=/opt/app-root/src/.jupyter
export JUPYTER_PATH=/opt/app-root/src/share/jupyter
export JUPYTER_RUNTIME_DIR=/opt/app-root/src/share/jupyter/runtime

exec jupyter lab

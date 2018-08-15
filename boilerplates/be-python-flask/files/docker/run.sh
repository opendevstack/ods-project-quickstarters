#!/usr/bin/env bash

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

# Install custom python package if requirements.txt is present
if [ -e "requirements.txt" ]; then
    $(which pip) install --user -r requirements.txt
fi

exec python3 app.py

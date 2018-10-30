#!/bin/bash

# Set current user in nss_wrapper
USER_ID=$(id -u)
GROUP_ID=$(id -g)

if [ x"$USER_ID" != x"0" -a x"$USER_ID" != x"1001" ]; then

    NSS_WRAPPER_PASSWD=/opt/app-root/etc/passwd
    NSS_WRAPPER_GROUP=/etc/group

    cat /etc/passwd | sed -e 's/^default:/builder:/' > $NSS_WRAPPER_PASSWD

    echo "default:x:${USER_ID}:${GROUP_ID}:Default Application User:${HOME}:/sbin/nologin" >> $NSS_WRAPPER_PASSWD

    export NSS_WRAPPER_PASSWD
    export NSS_WRAPPER_GROUP

    LD_PRELOAD=libnss_wrapper.so
    export LD_PRELOAD
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
#pip install -i https://$NEXUS_USER:NEXUS_PASSOWRD@nexus3-cd.22ad.bi-x.openshiftapps.com/repository/pypi-all/simple -r requirements.txt

pip install -i https://$NEXUS_USER:$NEXUS_PASSOWRD@$NEXUS_URL/pypi-all/simple -r requirements.txt

exec jupyter lab

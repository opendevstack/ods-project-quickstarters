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

# Code fixes problem with 2 installations of Python of different versions.
source scl_source enable httpd24 python27 && \
source /opt/app-root/bin/activate && \
pip install -r requirements.txt
cp /opt/rh/python27/root/usr/bin/python /opt/app-root/bin/python && \
exec python app.py
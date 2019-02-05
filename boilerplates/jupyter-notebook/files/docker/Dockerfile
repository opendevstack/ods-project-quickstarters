# This image provides a jupyter notebook setup
FROM ubuntu:16.04

MAINTAINER "Stefan Klingelschmitt" <stefan.klingelschmitt@boehringer-ingelheim.com>

EXPOSE 8080

# Add Cloudera apt repo for the hive jdbc driver
RUN apt-key adv --fetch-keys http://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh/archive.key && \
    echo 'deb [arch=amd64] http://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh xenial-cdh5 contrib' > /etc/apt/sources.list.d/cloudera.list

ENV localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG=C.UTF-8
ENV PYTHON_VERSION=3.5 \
    PATH=$HOME/.local/bin/:/opt/app-root/src/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    PIP_NO_CACHE_DIR=off
ENV SHELL /bin/bash

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    ssh \
    git \
    vim \
    wget \
    less \
    libnss-wrapper \
    gfortran \
    liblapack-dev \
    pkg-config \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-dev \
    libkrb5-dev \
    rsync \
    software-properties-common \
    unzip \
    python3-virtualenv \
    libsasl2-dev \
    postgresql postgresql-contrib \
    # needed for hive connection
    default-jre \
    hive-jdbc \
    libssl-dev libcurl4-openssl-dev libssl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip==9.0.1 &&  \
    pip3 install virtualenv --upgrade


ENV LANG=C.UTF-8

RUN virtualenv /opt/app-root -p /usr/bin/python3

COPY run.sh /opt/app-root/src/
COPY requirements.txt /opt/app-root/src/
COPY jupyter_notebook_config.json /opt/app-root/src/.jupyter/jupyter_notebook_config.json


WORKDIR /opt/app-root/src/

# In order to drop the root user, we have to make some directories world
# writable as OpenShift default security model is to run the container under
# random UID.
RUN chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root

USER 1001

# Set the default CMD to print the usage of the language image.
CMD ["./run.sh"]

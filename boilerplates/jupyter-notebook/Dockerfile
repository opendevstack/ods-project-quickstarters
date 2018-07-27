# This image provides a jupyter notebook setup
FROM ubuntu:16.04

MAINTAINER "Stefan Klingelschmitt" <stefan.klingelschmitt@boehringer-ingelheim.com>

EXPOSE 8080

# Add Cloudera apt repo for the hive jdbc driver
RUN apt-key adv --fetch-keys http://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh/archive.key && \
    echo 'deb [arch=amd64] http://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh xenial-cdh5 contrib' > /etc/apt/sources.list.d/cloudera.list

ENV PYTHON_VERSION=2.7 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off


RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        git \
        libnss-wrapper \
        gfortran \
        liblapack-dev \
        pkg-config \
        python \
        python-dev \
        rsync \
        software-properties-common \
        unzip \
        python-virtualenv \
        libsasl2-dev \
        postgresql postgresql-contrib \
        # needed for hive connection
        default-jre \
        hive-jdbc \
        libssl-dev libcurl4-openssl-dev libssl-dev && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

RUN apt-get remove -y python3

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

# somehow the original installation of virtualenv is not found -> reinstall
RUN pip install virtualenv --upgrade

ENV LANG=C.UTF-8

RUN virtualenv /opt/app-root


COPY run.sh /opt/app-root/src/
COPY requirements.txt /opt/app-root/src/
COPY additionals.txt /opt/app-root/src/
COPY jupyter_notebook_config.json /opt/app-root/src/.jupyter/jupyter_notebook_config.json
COPY hive_datalake_example.ipynb /opt/app-root/src/work/hive_datalake_example.ipynb
# test
COPY hadoop-common-2.9.0.jar /usr/lib/hive/lib/hadoop-common-2.9.0.jar


WORKDIR /opt/app-root/src/

# In order to drop the root user, we have to make some directories world
# writable as OpenShift default security model is to run the container under
# random UID.
RUN chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root

# set user read/write capable R packages lib for install
# ENV R_LIBS=/opt/app-root/lib

USER 1001


# install python package to virtualenv.
# pip installations in two steps -> gurantees that dependencies are resovled before
RUN /bin/bash -c "source /opt/app-root/bin/activate && pip install -r requirements.txt &&  pip install -r additionals.txt"

# Set the default CMD to print the usage of the language image.
CMD ["./run.sh"]

FROM python:3.7.0-slim

MAINTAINER "Andras Gyacsok" <andras.gyacsok@boehringer-ingelheim.com>

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

ARG PROJECT_HOME=/opt/app-root/src
ARG HOME=${PROJECT_HOME}

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8

RUN set -ex  && \
    # DEPENDENCIES
    buildDeps=' \
        build-essential \
        python3-dev \
        python3-pip \
        zlib1g-dev \
        automake \
        make \
        libtool \
        m4 \
        automake \
        gettext \
    ' \
    apt-get update -yqq && \
    apt-get upgrade -yqq && \
    apt-get install -yqq --no-install-recommends \
        $buildDeps \
        apt-utils \
        locales \
        pkg-config && \
    sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 && \
    # PROJECT
    mkdir /opt/app-root && \
    useradd -ms /bin/bash -d ${PROJECT_HOME} -u 1001 prophet && \
    # CLEAN UP
    apt-get autoremove -yqq --purge && \
    apt-get clean


COPY run.sh ${PROJECT_HOME}
COPY dist ${PROJECT_HOME}


RUN chown -R prophet: ${PROJECT_HOME} && \
    chgrp -R 0 ${PROJECT_HOME} && \
    chmod -R g=u ${PROJECT_HOME} && \
    chmod g=u /etc/passwd && \
    chmod u+x ${PROJECT_HOME}/run.sh

EXPOSE 8080

ENV HOME=${PROJECT_HOME}
WORKDIR ${PROJECT_HOME}


USER 1001

CMD ["./run.sh"]


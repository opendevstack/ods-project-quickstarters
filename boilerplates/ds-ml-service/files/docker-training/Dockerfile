FROM registry.access.redhat.com/rhscl/python-36-rhel7

ARG nexus_username
ARG nexus_password
ARG nexus_url
WORKDIR /app

ENV DSI_MINICONDA_PACKAGE_VERSION="3.6.0"
ENV DSI_MINICONDA_PACKAGE_PATH=/app/miniconda3.sh
ENV PYTHONPATH=$PYTHONPATH:/app
ENV DSI_PACKAGE=/app/app.tar.gz

ENV NEXUS_USERNAME=$nexus_username
ENV NEXUS_PASSWORD=$nexus_password
ENV NEXUS_URL=$nexus_url

# Front load pip install, miniconda download for caching docker build layers
COPY dist/requirements.txt /app

USER root

RUN curl --silent --fail https://repo.anaconda.com/miniconda/Miniconda3-${DSI_MINICONDA_PACKAGE_VERSION}-Linux-x86_64.sh --output ${DSI_MINICONDA_PACKAGE_PATH}

USER 1001

RUN pip install --upgrade pip && \
    if [[ ! -z ${nexus_url} ]]; \
    then pip install -i https://${nexus_username}:${nexus_password}@${nexus_url:8}/repository/pypi-all/simple -r requirements.txt; \
    else pip install -r requirements.txt; \
    fi

# Copying all the code
COPY dist /app

USER root

# Is needed that the special user (1001) has the permissions for starting python servers
RUN chgrp -R 0 /app && \
    chmod -R g=u /app && \
    chmod +x /app/run.sh && \
    chmod g+w /etc/passwd && \
    tar zcf /app/app.tar.gz *


USER 1001

EXPOSE 8080

ENTRYPOINT [ "/app/run.sh" ]
CMD [ "services/training/app.py", "--port" , "8080"]

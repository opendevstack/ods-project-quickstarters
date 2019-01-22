FROM registry.access.redhat.com/rhscl/python-36-rhel7

ARG NEXUS_USERNAME
ARG NEXUS_PASSWORD
ARG NEXUS_URL
WORKDIR /app

# From load pip install, miniconda download for caching docker build layers

ENV DSI_MINICONDA_PACKAGE_PATH=/app/miniconda3.sh
ENV PYTHONPATH=$PYTHONPATH:/app
ENV DSI_PACKAGE=/app/app.tar.gz

ENV NEXUS_USERNAME=$NEXUS_USERNAME
ENV NEXUS_PASSWORD=$NEXUS_PASSWORD
ENV NEXUS_URL=$NEXUS_URL

COPY dist/run.sh /app/run.sh
COPY dist/requirements.txt /app

USER root

RUN curl --silent --fail https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh --output ${DSI_MINICONDA_PACKAGE_PATH}

USER 1001

RUN pip install --upgrade pip && \
    if [[ ! -z ${NEXUS_URL} ]]; \
    then pip install -i https://${NEXUS_USERNAME}:${NEXUS_PASSWORD}@${NEXUS_URL:8}/repository/pypi-all/simple -r requirements.txt; \
    else pip install -r requirements.txt; \
    fi

# Copying all the code
COPY dist /app

USER root

# Is needed that the special user (1001) needed for starting python servers has the permissions
RUN chgrp -R 0 /app && \
    chmod -R g=u /app && \
    chmod +x /app/run.sh && \
    chmod g+w /etc/passwd && \
    tar zcf /app/app.tar.gz *


USER 1001

EXPOSE 8080

ENTRYPOINT [ "/app/run.sh" ]
CMD [ "services/training/app.py", "--port" , "8080"]
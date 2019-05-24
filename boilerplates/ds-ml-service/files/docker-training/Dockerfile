FROM registry.access.redhat.com/rhscl/python-36-rhel7


WORKDIR /app

ENV DSI_MINICONDA_PACKAGE_VERSION="3.6.0"
ENV DSI_MINICONDA_PACKAGE_PATH=/app/miniconda3.sh
ENV PYTHONPATH=$PYTHONPATH:/app
ENV DSI_PACKAGE=/app/app.tar.gz

ARG nexusHostWithBasicAuth

# Front load pip install, miniconda download for caching docker build layers
COPY dist/requirements.txt /app

USER root

RUN curl --silent --fail https://repo.anaconda.com/miniconda/Miniconda3-${DSI_MINICONDA_PACKAGE_VERSION}-Linux-x86_64.sh --output ${DSI_MINICONDA_PACKAGE_PATH}

USER 1001

RUN if [[ ! -z ${nexusHostWithBasicAuth} ]]; \
    then  pip install -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithBasicAuth}/repository/pypi-all/simple --upgrade pip && pip install -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithBasicAuth}/repository/pypi-all/simple -r requirements.txt; \
    else pip install --upgrade pip && pip install -r requirements.txt; \
    fi

# Copying all the code
COPY dist /app

USER root

# Is needed that the special user (1001) has the permissions for starting python servers
RUN chgrp -R 0 /app && \
    chmod -R g=u /app && \
    chmod +x /app/run.sh && \
    chmod g+w /etc/passwd && \
    touch /app/app.tar.gz && \
    tar zcf /app/app.tar.gz ./ --exclude=./app.tar.gz


USER 1001

EXPOSE 8080

ENTRYPOINT [ "/app/run.sh" ]
CMD [ "services/training/app.py", "--port" , "8080"]

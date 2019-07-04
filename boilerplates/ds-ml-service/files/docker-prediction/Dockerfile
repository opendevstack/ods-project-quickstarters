FROM registry.access.redhat.com/rhscl/python-36-rhel7

ARG nexusHostWithBasicAuth
ARG nexusHostWithoutScheme

WORKDIR /app

ENV PYTHONPATH=$PYTHONPATH:/app


COPY dist/requirements.txt /app


USER 1001

# Front load pip install for caching docker build layers
RUN if [[ ! -z ${nexusHostWithBasicAuth} ]]; \
    then  pip install -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithoutScheme} --upgrade pip && pip install -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple --trusted-host ${nexusHostWithoutScheme} -r requirements.txt; \
    else pip install --upgrade pip && pip install -r requirements.txt; \
    fi

COPY dist /app

USER root

# Is needed that the special user (1001) has the permissions for starting python servers
RUN chgrp -R 0 /app && \
    chmod -R g=u /app && \
    chmod +x /app/run.sh && \
    chmod g+w /etc/passwd

USER 1001

EXPOSE 8080

ENTRYPOINT [ "/app/run.sh" ]
CMD [ "services/prediction/app.py", "--port" , "8080"]
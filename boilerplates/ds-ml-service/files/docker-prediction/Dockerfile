FROM registry.access.redhat.com/rhscl/python-36-rhel7

ARG nexus_username
ARG nexus_password
ARG nexus_url

WORKDIR /app

ENV PYTHONPATH=$PYTHONPATH:/app

COPY dist/requirements.txt /app

USER 1001

# Front load pip install for caching docker build layers
RUN pip install --upgrade pip && \
    if [[ ! -z ${nexus_url} ]]; \
    then pip install -i https://${nexus_username}:${nexus_password}@${nexus_url:8}/repository/pypi-all/simple -r requirements.txt; \
    else pip install -r requirements.txt; \
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

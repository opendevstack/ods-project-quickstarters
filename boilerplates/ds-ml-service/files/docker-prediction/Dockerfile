FROM registry.access.redhat.com/rhscl/python-36-rhel7

ARG NEXUS_USERNAME
ARG NEXUS_PASSWORD
ARG NEXUS_URL

WORKDIR /app

ENV PYTHONPATH=$PYTHONPATH:/app
COPY dist/run.sh /app/run.sh

COPY dist/requirements.txt /app

USER 1001
# From load pip install for caching docker build layers
RUN pip install --upgrade pip && \
    if [[ ! -z ${NEXUS_URL} ]]; \
    then pip install -i https://${NEXUS_USERNAME}:${NEXUS_PASSWORD}@${NEXUS_URL:8}/repository/pypi-all/simple -r requirements.txt; \
    else pip install -r requirements.txt; \
    fi

COPY dist /app

USER root

RUN chgrp -R 0 /app && \
    chmod -R g=u /app && \
    chmod +x /app/run.sh && \
    chmod g+w /etc/passwd

USER 1001

EXPOSE 8080

ENTRYPOINT [ "/app/run.sh" ]
CMD [ "services/prediction/app.py", "--port" , "8080"]
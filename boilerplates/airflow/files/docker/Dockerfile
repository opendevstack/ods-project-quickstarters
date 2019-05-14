# This is a dummy value which OpenShift replaces during build time
FROM oc.registry.url/shared-services/airflow:1.10.3

ARG nexus_username
ARG nexus_password
ARG nexus_url

COPY dist/requirements.txt ${AIRFLOW_HOME}/
COPY dist/dags ${AIRFLOW_HOME}/dags
COPY dist/dag_deps ${AIRFLOW_HOME}/dag_deps
COPY scripts/setup.py ${AIRFLOW_HOME}/dag_deps

USER root

RUN pip install ${AIRFLOW_HOME}/dag_deps && \
    if [[ ! -z ${nexus_url} ]]; \
    then pip install -i https://${nexus_username}:${nexus_password}@${nexus_url:8}/repository/pypi-all/simple -r ${AIRFLOW_HOME}/requirements.txt; \
    else pip install -r ${AIRFLOW_HOME}/requirements.txt; \
    fi

USER 1001
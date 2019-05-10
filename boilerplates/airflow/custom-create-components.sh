#!/usr/bin/env bash

# This script sets up the resource objects for a certain component:
# * image streams
# * build configs: pipelines
# * build configs: images
# * services
# * environment variables

# Use -gt 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use -gt 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to -gt 0 the /etc/hosts part is not recognized ( may be a bug )
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -p|--project)
    PROJECT="$2"
    shift # past argument
    ;;
    -c|--component)
    COMPONENT="$2"
    shift # past argument
    ;;
    -b|--bitbucket)
    BITBUCKET_REPO="$2"
    shift # past argument
    ;;
    -ne|--nexus)
    NEXUS_HOST="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

if [ -z ${PROJECT+x} ]; then
    echo "PROJECT is unset, but required";
    exit 1;
else echo "PROJECT=${PROJECT}"; fi
if [ -z ${COMPONENT+x} ]; then
    echo "COMPONENT is unset, but required";
    exit 1;
else echo "COMPONENT=${COMPONENT}"; fi
if [ -z ${NEXUS_HOST+x} ]; then
    echo "NEXUS_HOST is unset, but required";
    exit 1;
else echo "NEXUS_HOST=${NEXUS_HOST}"; fi


# iterate over different environments
for ENV in dev test ; do

    # Creating service account and bindings
    oc create -f templates/service-account.json -n ${PROJECT}-${ENV}
    oc create rolebinding airflow-admin-binding --serviceaccount ${PROJECT}-${ENV}:airflow --clusterrole admin -n ${PROJECT}-${ENV}

    # Creating PostgreSQL resources 
    oc process -f templates/postgresql-persistent.json | oc create -n ${PROJECT}-${ENV} -f - 

    # Creating ElasticSearch resources
    oc process -f ../../../ocp-templates/templates/elasticsearch/elasticsearch-persistent-master-template.yaml \
        COMPONENT_NAME=airflow-elasticsearch \
        CLUSTER_NAME=airflow \
        NAMESPACE=${PROJECT}-${ENV} \
        VOLUME_SIZE_IN_GI=1 | oc create -n ${PROJECT}-${ENV} -f -

    # Create Airflow resources
    # TODO:  Values to be set/defined "Docker Registry IP/HOST", "OpenShift console URL"
    oc process -f templates/airflow.json NAMESPACE=${PROJECT}-${ENV} | oc create -n ${PROJECT}-${ENV} -f -

    
done

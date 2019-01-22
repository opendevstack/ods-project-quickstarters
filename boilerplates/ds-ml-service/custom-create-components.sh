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
for devenv in dev test ; do
    for type in training-service prediction-service ; do
        # create resources
        echo "${PROJECT} -- ${COMPONENT}-${type} -- ${BITBUCKET_REPO}"
        oc process cd//component-environment PROJECT=${PROJECT} COMPONENT=${COMPONENT}-${type} ENV=${devenv}  | oc create -n ${PROJECT}-${devenv} -f-

        # create image build configs
        oc process cd//bc-docker PROJECT=${PROJECT} COMPONENT=${COMPONENT}-${type} ENV=${devenv} | oc create -n ${PROJECT}-${devenv} -f-

        # create component environment variables
        echo "environment variables for component type ${type}";
        if [ ${type} = "training-service" ]; then
            oc create secret generic ${COMPONENT}-training-secret --from-literal=username=${COMPONENT}-training-username --from-literal=password=`dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64  | rev | cut -b 2- | rev | tr -cd '[:alnum:]'` -n ${PROJECT}-${devenv}
            oc set triggers dc/${COMPONENT}-${type} --from-config --remove -n ${PROJECT}-${devenv}
            oc env dc/${COMPONENT}-${type} --env=DSI_EXECUTE_ON=LOCAL -n ${PROJECT}-${devenv}
            oc env dc/${COMPONENT}-${type} --from=secret/${COMPONENT}-training-secret --prefix=DSI_TRAINING_SERVICE_ -n ${PROJECT}-${devenv}
            oc set triggers dc/${COMPONENT}-${type} --from-config -n ${PROJECT}-${devenv}
        else
            oc create secret generic ${COMPONENT}-prediction-secret --from-literal=username=${COMPONENT}-prediction-username --from-literal=password=`dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64  | rev | cut -b 2- | rev | tr -cd '[:alnum:]'` -n ${PROJECT}-${devenv}
            oc set triggers dc/${COMPONENT}-${type} --from-config --remove -n ${PROJECT}-${devenv}
            oc env dc/${COMPONENT}-${type} --env=DSI_TRAINING_BASE_URL=http://${COMPONENT}-training-service.${PROJECT}-${devenv}.svc:8080 -n ${PROJECT}-${devenv}
            oc env dc/${COMPONENT}-${type} --from=secret/${COMPONENT}-training-secret --prefix=DSI_TRAINING_SERVICE_ -n ${PROJECT}-${devenv}
            oc env dc/${COMPONENT}-${type} --from=secret/${COMPONENT}-prediction-secret --prefix=DSI_PREDICTION_SERVICE_ -n ${PROJECT}-${devenv}
            oc set triggers dc/${COMPONENT}-${type} --from-config -n ${PROJECT}-${devenv}
        fi

    done
done

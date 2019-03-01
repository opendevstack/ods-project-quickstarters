#!/usr/bin/env bash

# This deletes the resource objects for a certain component:
# * image streams
# * build configs: pipelines
# * build configs: images
# * services
# * routes

# Use -gt 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use -gt 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example)# This script sets up the resource objects for a certain component:
# * image streams
# * build configs: pipelines
# * build configs: images
# * services
# * routes

# Use -gt 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use -gt 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to -gt 0 the /etc/hosts part is not recognized ( may be a bug )

STATUS=false
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --status)
    STATUS=true
    ;;
    -p|--project)
    PROJECT="$2"
    shift # past argument
    ;;
    -c|--component)
    COMPONENT="$2"
    shift # past argument
    ;;
    *)
    echo "Ignoring unknown option: $1"
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

if $STATUS; then
    echo "NOTE: Invoked with --status: List resources to be deleted instead of deleting them."
fi

# Removing resources created with create-component.sh
# These all have at least the following labels:
#   app: '${PROJECT}'
#   component: '${COMPONENT}'
#   env: '${ENV}'
# create-component.sh uses 3 templates which have the following
# additional label:
#   template: component-template
#   template: component-route-template
#   template: bc-docker

# The following code uses these labels to select the resources to be deleted.

templates=(component-template component-route-template bc-docker)

for devenv in dev test ; do
    NS=${PROJECT}-${devenv}
    NS_ARG="--namespace=${NS}"
    NS_SELECTOR_BASE="app=${PROJECT},component=${COMPONENT},env=${devenv}"

    echo # extra newline
    echo "Deleting component ${COMPONENT} in environment $NS:"

    for template in "${templates[@]}"; do
        if $STATUS; then
            oc get all "${NS_ARG}" \
                --selector "${NS_SELECTOR_BASE},template=$template" \
                -o name
        else
            oc delete all "${NS_ARG}" \
                --selector "${NS_SELECTOR_BASE},template=$template" \
                -o name
        fi
    done
done

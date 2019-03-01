#!/usr/bin/env bash

# This script sets up the resource objects for a certain component:
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
    -b|--bitbucket)
    BITBUCKET_REPO="$2"
    shift # past argument
    ;;
    *)
    echo "Ignoring unknown option: $1"
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

# Removing resources created with create-rshiny-app.sh
# There are templates with component specific labels:
# 1.
#   template: rshiny
#   app: '${PROJECT}'
#   component: '${COMPONENT}'
#   env: '${ENV}'
# 2.
#   template: rshiny-authproxy
#   app: '${PROJECT}'
#   component: '${COMPONENT}'-authproxy
#   env: '${ENV}'
# 3.
#   template: rshiny-secrets
# 4.
#   template: bc-docker
#   app: '${PROJECT}'
#   component: '${COMPONENT}'
#   env: '${ENV}'
#
# Note that template rshiny-secrets would be shared by multiple components and thus will not be deleted here.

# belows arrays are visited by index and must have matching entries:
components=("$COMPONENT" "$COMPONENT-authproxy" "$COMPONENT")
templates=(rshiny rshiny-authproxy bc-docker)


for devenv in dev test ; do
    NS=${PROJECT}-${devenv}
    NS_ARG="--namespace=${NS}"

    echo # extra newline
    echo "Deleting component ${COMPONENT} in environment $NS:"

    for i in "${!templates[@]}"; do
        comp=${components[$i]}
        templ=${templates[$i]}

        NS_SELECTOR_BASE="app=${PROJECT},component=${comp},env=${devenv}"
        if $STATUS; then
            oc get all "${NS_ARG}" \
                --selector "${NS_SELECTOR_BASE},template=$templ" \
                -o name
        else
            oc delete all "${NS_ARG}" \
                --selector "${NS_SELECTOR_BASE},template=$templ" \
                -o name
        fi
    done
    echo "NOTE: shared resources are not deleted in environment $NS:"
    oc get secret "${NS_ARG}" \
        --selector "template=rshiny-secrets" \
        -o name
done

#!/usr/bin/env bash

# This deletes the resource objects for a certain component:
# * image streams
# * build configs: pipelines
# * build configs: images
# * services
# * routes

# support pointing to patched tailor using TAILOR environment variable
: ${TAILOR:=tailor}

tailor_exe=$(type -P ${TAILOR})
tailor_version=$(${TAILOR} version)

echo "Using tailor ${tailor_version} from ${tailor_exe}"

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

ROUTE="false"
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
    -r|--route)
    ROUTE="true"
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

VERBOSE=false
while [[ $# -gt 0 ]]; do
key="$1"
case $key in
    -v|--verbose)
        VERBOSE=true
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

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

delete_tailordir() {
    local context="$1"; shift
    local dir="$1"; shift
    echo "$context: Determing which resources to delete based on templates in $dir"

    tailor_verbose=""
    if  $VERBOSE; then
        tailor_verbose="-v"
    fi

    local todelete=$(cd "$dir" && ${TAILOR} $tailor_verbose export "$@" | oc process --local -o go-template='{{if .items}}{{range .items}}{{.kind}}{{"/"}}{{.metadata.name}},{{end}}{{end}}' -f -)

    if [ -z ${todelete+x} ]; then
        echo "$context: No resources found to be deleted.";
    else
        echo "$context: Deleting the following resources: ${todelete}."
    fi
}


for devenv in dev test ; do

    OCP_CONFIG="${SCRIPT_DIR}/../ocp-config"
    NS_ARG="--namespace=${PROJECT}-${devenv}"
    NS_SELECTOR_BASE="app=${PROJECT},component=${COMPONENT},env=${devenv}"

    context=${PROJECT}-${devenv}
	echo "$context: Deleting component ${COMPONENT}."
    delete_tailordir "$context" "${OCP_CONFIG}/component-environment" \
        "${NS_ARG}" --selector "${NS_SELECTOR_BASE},template=component-template"

    # not sure we want a paramneter here.
    if $ROUTE; then
        echo "deleting route"
        delete_tailordir "$context" "${OCP_CONFIG}/component-route" \
            "${NS_ARG}" --selector "${NS_SELECTOR_BASE},template=component-route-template"
    fi

	echo "deleting environment bc"
    delete_tailordir "$context" "${OCP_CONFIG}/bc-docker" \
        "${NS_ARG}" --selector "${NS_SELECTOR_BASE},template=bc-docker"
done

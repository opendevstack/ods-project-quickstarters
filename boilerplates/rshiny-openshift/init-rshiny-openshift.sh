#!/usr/bin/env bash
set -eu

# Generates 'openshift' folder for rshiny in generated boilerplate.
# This is based on https://github.com/opendevstack/ods-jenkins-shared-library/pull/85

# Parameters are passed as environment variables only!
usage_and_exit() {
    echo "Usage: PROJECT=.. COMPONENT=.. TARGET_DIR=.. ./init-openshift.sh "
    exit 1;
}

if [ "$#" -gt 0 ]; then
    echo "Script does not use parameters."
    usage_and_exit
fi

cat <<ECHO_USED_ENV_VARIABLES || usage_and_exit
Using environment variables:
  - PROJECT=[$PROJECT]
  - COMPONENT=[$COMPONENT]
  - TARGET_DIR=[$TARGET_DIR]
ECHO_USED_ENV_VARIABLES


# Get directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


QS_DIR="${SCRIPT_DIR%/*/*}"
if [ "${QS_DIR##*/}" != "ods-project-quickstarters" ]; then
    echo "Bug: should have evaluated to ods-project-quickstarters but was [${QS_DIR##*/}]"
    exit 2
fi

# config needed for template parameters.
CONFIG_DIR="${QS_DIR%/*}/ods-configuration"
if [ ! -d "${CONFIG_DIR}" ]; then
    echo "Must be invoked with ods-configuration at [${CONFIG_DIR}]"
    exit 1
fi

OPENSHIFT_DIR="${TARGET_DIR}/openshift"
if [ -d "${OPENSHIFT_DIR}" ]; then
    echo "${OPENSHIFT_DIR} already exists, leaving it alone"
    exit 0;
fi

mkdir "${OPENSHIFT_DIR}" && cd "${OPENSHIFT_DIR}"
echo "Generating files in ${PWD}"

# The openshift folder is used by code originating from
# https://github.com/opendevstack/ods-jenkins-shared-library/pull/85

# iterate over different environments
environments=(test dev)
for ENV in "${environments[@]}" ; do
    # env file
    echo "Writing env file for tailor:  ${PROJECT}-${ENV}.env"
    cat << TAILOR_ENV > "${PROJECT}-${ENV}.env"
# general settings
PROJECT=${PROJECT}
COMPONENT=${COMPONENT}
ENV=${ENV}

TAILOR_ENV
    cat "${CONFIG_DIR}/ods-project-quickstarters/ocp-templates/templates/templates.env" >> "${PROJECT}-${ENV}.env"

    # .. indenting heredocs is fragile as it requires tabs.
    # matching tailor file
    echo "Writing tailor file:  Tailorfile.${PROJECT}-${ENV}"
    cat << TAILORFILE > "Tailorfile.${PROJECT}-${ENV}"
namespace ${PROJECT}-${ENV}
param-file ${PROJECT}-${ENV}.env
ignore-unknown-parameters true
secret,svc,route,dc,is
ignore-path bc:/spec/output/to/name,bc:/spec/output/imageLabels
TAILORFILE
done

# '*'' does not expand in double quotes
cp -v "${QS_DIR}"/boilerplates/rshiny-openshift/openshift/*.yml .
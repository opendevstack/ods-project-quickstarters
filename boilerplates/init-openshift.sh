#!/usr/bin/env bash
set -eu

# Generates default openshift setup.
#   This is generated in the 'openshift' folder of the specified target directory.
#
#   To customize, for example to introduce additional services use a similar
#   script specific to your quickstarter.

# Get directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


QS_DIR="${SCRIPT_DIR%/*}"
if [ "${QS_DIR##*/}" != "ods-project-quickstarters" ]; then
    echo "Bug: should have evaluated to ods-project-quickstarters but was [${QS_DIR##*/}]"
    exit 2
fi

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

OPENSHIFT_DIR="${TARGET_DIR}/openshift"
if [ -d "${OPENSHIFT_DIR}" ]; then
    echo "${OPENSHIFT_DIR} already exists, leaving it alone"
    exit 0;
fi

mkdir "${OPENSHIFT_DIR}" && cd "${OPENSHIFT_DIR}"
echo "Generating file in ${PWD}"

# sudo chgrp -R 0 . # asks for password

# iterate over different environments
# this is based on https://github.com/opendevstack/ods-jenkins-shared-library/pull/85
environments=(test dev)
for ENV in "${environments[@]}" ; do
    # env file
    echo "Writing env file for tailor:  ${PROJECT}-${ENV}.env"
    cat << TAILOR_ENV > "${PROJECT}-${ENV}.env"
PROJECT=${PROJECT}
COMPONENT=${COMPONENT}
ENV=${ENV}
TAILOR_ENV
    # .. indenting heredocs is fragile as it requires tabs.
    # matching tailor file
    echo "Writing tailor file:  Tailorfile.${PROJECT}-${ENV}"
    cat << TAILORFILE > "Tailorfile.${PROJECT}-${ENV}"
namespace ${PROJECT}-${ENV}
param-file ${PROJECT}-${ENV}.env
svc,dc,is,bc
ignore-unknown-parameters true
ignore-path bc:/spec/output/to/name,bc:/spec/output/imageLabels
TAILORFILE
done

# * does not expand in double quotes
cp -v "${QS_DIR}"/ocp-templates/ocp-config/component-environment/*.yml .
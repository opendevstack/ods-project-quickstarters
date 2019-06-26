#!/usr/bin/env bash
set -e # exit on error
set -u # exit when environment variable is not defined.

# Generates default openshift setup for tailor .
#   This tailor files and openshift template yaml files are generated in
#   the 'openshift' folder of the specified TARGET_DIR.
#
# If this folder already exists this script leaves it alone.
#
# The openshift folder is used from jenkins shared library stages to
# invoke tailor to update openshift resources.
# The code originates from https://github.com/opendevstack/ods-jenkins-shared-library/pull/85
#
# To customize you can replace the subscripts invoked by placing scripts with
# the matching names into your components boilerplates root folder at
# "$BOILERPLATES_DIR/$COMPONENT_TYPE/:
#
# 1. renderTailorEnv.sh:
#    Generate env file used by tailor script in next step.
#    Name should be "${PROJECT}-${ENV}.env"
#    NOTES: Is invoked with CONFIG_DIR setup so that variable values can be
#    grabbed from there.
# 2. renderTailorfile.sh:
#    Generate Tailorfile for the Openshift Yml files generated in
#    the next step.
#    Name must be "Tailorfile.${PROJECT}-${ENV}" in order for the shared
#    library to  properly invoke tailor.
# 3. renderOpenshiftYml.sh:
#    Copies or generate Openshift template Yml files used by tailor.

# Parameters are passed as environment variables only!
# This allows passing them to subscripts without adding more parameter handling.
usage_and_exit() {
    echo "Usage: PROJECT=.. COMPONENT=.. COMPONENT_TYPE=.. TARGET_DIR=.. ./init-openshift.sh "
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
  - COMPONENT_TYPE=[$COMPONENT_TYPE]
  - TARGET_DIR=[$TARGET_DIR]
ECHO_USED_ENV_VARIABLES

# Get directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

BOILERPLATES_DIR="$SCRIPT_DIR"
export BOILERPLATES_DIR # so render scripts can use it

QS_DIR="${SCRIPT_DIR%/*}"
if [ "${QS_DIR##*/}" != "ods-project-quickstarters" ]; then
    echo "Bug: should have evaluated to ods-project-quickstarters but was [${QS_DIR##*/}]"
    exit 2
fi
export QS_DIR # so render scripts can use it

# config may be needed in case customized templates require variables
# although this script does not require them.
CONFIG_DIR="${QS_DIR%/*}/ods-configuration"
if [ ! -d "${CONFIG_DIR}" ]; then
    echo "Must be invoked with ods-configuration at [${CONFIG_DIR}]"
    exit 1
fi
export CONFIG_DIR

OPENSHIFT_DIR="${TARGET_DIR}/openshift"
if [ -d "${OPENSHIFT_DIR}" ]; then
    echo "${OPENSHIFT_DIR} already exists, leaving it alone"
    exit 0;
fi

# Note: mkdir -p "${OPENSHIFT_DIR}" && cd "${OPENSHIFT_DIR}" did not exit
# in my testing when mkdir exits with an error.
mkdir -p "${OPENSHIFT_DIR}"
cd "${OPENSHIFT_DIR}"
echo "Generating files in ${PWD}"

# sudo chgrp -R 0 . # asks for password

# iterate over different environments
environments=(test dev)
for ENV in "${environments[@]}" ; do
    # tailor env file
    if [ -e "$BOILERPLATES_DIR/$COMPONENT_TYPE/renderTailorEnv.sh" ]; then # not using -x for better error handling and messages.
        ENV=$ENV "$BOILERPLATES_DIR/$COMPONENT_TYPE/renderTailorEnv.sh"
    else
        ENV=$ENV "$BOILERPLATES_DIR/renderTailorEnv.sh"
    fi
    # tailor file
    if [ -e "$BOILERPLATES_DIR/$COMPONENT_TYPE/renderTailorfile.sh" ]; then
        ENV=$ENV "$BOILERPLATES_DIR/$COMPONENT_TYPE/renderTailorfile.sh"
    else
        ENV=$ENV "$BOILERPLATES_DIR/renderTailorfile.sh"
    fi
done;

if [ -e "$BOILERPLATES_DIR/$COMPONENT_TYPE/renderOpenshiftYml.sh" ]; then
    ENV=$ENV "$BOILERPLATES_DIR/$COMPONENT_TYPE/renderOpenshiftYml.sh"
else
    ENV=$ENV "$BOILERPLATES_DIR/renderOpenshiftYml.sh"
fi


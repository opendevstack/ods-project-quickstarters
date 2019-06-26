#!/usr/bin/env bash
set -eu

echo "Writing env file for tailor: ${PROJECT}-${ENV}.env"

cat << TAILOR_ENV > "${PROJECT}-${ENV}.env"
# general settings
PROJECT=${PROJECT}
COMPONENT=${COMPONENT}
ENV=${ENV}

TAILOR_ENV

cat "${CONFIG_DIR}/ods-project-quickstarters/ocp-templates/templates/templates.env" >> "${PROJECT}-${ENV}.env"

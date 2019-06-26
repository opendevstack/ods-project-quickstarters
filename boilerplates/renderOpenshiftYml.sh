#!/usr/bin/env bash
set -eu

# * does not expand in double quotes
cp -v "${QS_DIR}"/ocp-templates/ocp-config/component-environment/*.yml .

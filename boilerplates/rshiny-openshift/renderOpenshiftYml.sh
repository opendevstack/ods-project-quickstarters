#!/usr/bin/env bash
set -eu

# '*'' does not expand in double quotes
cp -v "${BOILERPLATES_DIR}"/rshiny-openshift/openshift/*.yml .
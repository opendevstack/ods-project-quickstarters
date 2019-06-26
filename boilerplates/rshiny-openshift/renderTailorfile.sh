#!/usr/bin/env bash
set -eu

echo "Writing : Tailorfile.${PROJECT}-${ENV}"
cat << TAILORFILE > "Tailorfile.${PROJECT}-${ENV}"
namespace ${PROJECT}-${ENV}
param-file ${PROJECT}-${ENV}.env
ignore-unknown-parameters true
secret,svc,route,dc,is
ignore-path bc:/spec/output/to/name,bc:/spec/output/imageLabels
TAILORFILE

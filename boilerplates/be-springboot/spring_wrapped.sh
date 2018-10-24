#!/usr/bin/env bash
set -eux

echo "Spring CLI wrapper Arguments:"
for an_arg in "$@" ; do
   echo "${an_arg}"
done

. ./set_java_proxy.sh

./spring "$@"
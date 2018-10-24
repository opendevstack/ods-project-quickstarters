#!/usr/bin/env bash
set -eux

echo "Spring CLI wrapper Arguments:"
for an_arg in "$@" ; do
   echo "${an_arg}"
done

if [[ $JAVA_OPTS == "" ]]; then
	echo "JOPTS not set"
	export JAVA_OPTS=
fi

. /tmp/set_java_proxy.sh

echo $JAVA_OPTS

./spring "$@"
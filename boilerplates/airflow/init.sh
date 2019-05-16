#!/usr/bin/env bash
set -eux

# Get directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while [[ "$#" > 0 ]]; do case $1 in
  -p=*|--project=*) PROJECT="${1#*=}";;
  -p|--project) PROJECT="$2"; shift;;

  -c=*|--component=*) COMPONENT="${1#*=}";;
  -c|--component) COMPONENT="$2"; shift;;

  -g=*|--group=*) GROUP="${1#*=}";;
  -g|--group) GROUP="$2"; shift;;

  -t=*|--target-dir=*) TARGET_DIR="${1#*=}";;
  -t|--target-dir) TARGET_DIR="$2"; shift;;

  -o=*|--owner=*) OWNER="${1#*=}";;
  -o|--owner) OWNER="$2"; shift;;

  *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done

if [[ "$COMPONENT" != "airflow-worker" ]]; then
  echo "the component must be named airflow-worker"
  exit 1
fi

cd $TARGET_DIR

if [[ "$COMPONENT" != "airflow-worker" ]]; then
  echo "the component must be named airflow-worker"
  exit 1
fi

mkdir -p $COMPONENT

cd $COMPONENT

sudo chown -R $OWNER .

echo "copy custom files from quickstart to generated project"
cp -rv $SCRIPT_DIR/files/. .

#!/usr/bin/env bash

GIT_REV_PARSE_HEAD=`git rev-parse HEAD`
GIT_REV_PARSE_HEAD_SHORT=`git rev-parse --short HEAD`
GIT_REV_PARSE_BRANCH=`git rev-parse --abbrev-ref HEAD`
GIT_TOP_LEVEL=`git rev-parse --show-toplevel`
GIT_REPO_NAME=`basename ${GIT_TOP_LEVEL}`
GIT_LAST_CHANGE=`git log -1`

echo "GIT_COMMIT = \"${GIT_REV_PARSE_HEAD}\"" > src/services/infrastructure/git_info.py
echo "GIT_COMMIT_SHORT = \"${GIT_REV_PARSE_HEAD_SHORT}\"" >> src/services/infrastructure/git_info.py
echo "GIT_BRANCH = \"${GIT_REV_PARSE_BRANCH}\"" >> src/services/infrastructure/git_info.py
echo "GIT_REPO_NAME = \"${GIT_REPO_NAME}\"" >> src/services/infrastructure/git_info.py
echo "GIT_LAST_CHANGE = \"\"\"${GIT_LAST_CHANGE}\"\"\"" >> src/services/infrastructure/git_info.py

rsync -ahq --progress --delete --exclude 'services/prediction' src/* docker-training/dist
rsync -ahq --progress --delete --exclude 'services/training' src/* docker-prediction/dist
cp resources/train.csv docker-training/dist/


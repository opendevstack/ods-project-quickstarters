#!/bin/bash

usage() {
    echo "usage: sh $0 -p <projectID> -o <openshift host> -h <git host> -c <http basic auth credentials \
for git host access> -e <target env to clone to> -s <source env to clone from: default is test>";
}

while [[ $# -gt 1 ]]
do
key="$1"
case $key in
    -p|--projectId)
    PROJECTID="$2"
    shift # past argument
    ;;
	-h|--bitbucketHost)
    BITBUCKETHOST="$2"
    shift # past argument
    ;;
    -c|--credentials)
    CRED="$2"
    shift # past argument
    ;;
    -e|--target_env)
    TARGETENV="$2"
    shift # past argument
    ;;
    -s|--source_env)
    SOURCEENV="$2"
    shift # past argument
    ;;
    -o|--openshiftHost)
    OPENSHIFTHOST="$2"
    shift # past argument
    ;;
    *)
    # unknown option
    usage
    exit 1
    ;;
esac
shift # past argument or value
done

# CHECKING INPUT VALUES (REQUIRED AND NON)
if [[ -z "$PROJECTID" ]]; then
    # fallback
    echo "[ERROR]: No project id set - required value"
    usage
    exit 1
fi
if [[ -z "$BITBUCKETHOST" ]]; then
    # fallback
    echo "[ERROR]: No git host set - required value"
    usage
    exit 1
fi
if [[ -z "$CRED" ]]; then
    # fallback
    echo "[ERROR]: No git credentials set - required value"
    usage
    exit 1
fi
if [[ -z "$TARGETENV" ]]; then
    # fallback
    echo "[ERROR]: No target environment set - required value"
    usage
    exit 1
fi
if [[ -z "$SOURCEENV" ]]; then
    # fallback
    echo "[INFO]: No source environment set - setting default to: test"
    SOURCEENV=test
fi
if [[ -z "$OPENSHIFTHOST" ]]; then
    # fallback
    echo "[ERROR]: No openshift host set - required value"
    usage
    exit 1
fi

echo "Here the params you provided: \
- PROJECTID: $PROJECTID \
- OPENSHIFTHOST: $OPENSHIFTHOST \
- BITBUCKETHOST: $BITBUCKETHOST \
- CRED: **** \
- SOURCEENV: $SOURCEENV \
- TARGETENV: $TARGETENV"
sleep 5

iterateBuildConfigs() {
  oc get bc --no-headers -n $PROJECTID-$SOURCEENV | awk '{print $1}' | while read BC; do
    echo "[INFO]: working over build config: $BC"
    sleep 1
    tagversion=$(oc export bc $BC -n $PROJECTID-$SOURCEENV | grep 'output' -A 3 | tail -n 1 | awk -F':' '{print $3}')
    oc set env bc $BC projectId=$PROJECTID componentId=$BC tagversion=$tagversion
    gitUrl="https://cd_user@$BITBUCKETHOST/scm/$PROJECTID/$PROJECTID-$BC.git"
    PATCH="{
    \"spec\": {
        \"output\": {
            \"to\": {
                \"kind\": \"ImageStreamTag\",
                \"name\": \"$BC:$tagversion\"
            }
        },
        \"runPolicy\": \"Serial\",
        \"source\": {
            \"type\": \"Git\",
            \"git\": {
                \"uri\": \"$gitUrl\",
                \"ref\": \"master\"
            },
            \"contextDir\": \"docker\",
            \"sourceSecret\": {
                \"name\": \"cd-user-token\"
            }
        },
        \"strategy\": {
            \"type\": \"Docker\",
            \"dockerstrategy\": {
                \"env\": [
                {
                    \"name\": \"projectId\",
                    \"value\": \"$PROJECTID\"
                },
                {
                    \"name\": \"componentId\",
                    \"value\": \"$BC\"
                },
                {
                    \"name\": \"tagversion\",
                    \"value\": \"$tagversion\"
                }
                ]
            }
        }
    }
    }"
    echo "[INFO]: patch to apply: $PATCH"
    oc patch bc $BC -n $TARGETPROJECT --patch "$PATCH"
    oc start-build $BC -n $TARGETPROJECT --wait
    oc tag -n $TARGETPROJECT $BC:$tagversion $BC:latest
  done
}

# STARTING
TARGETPROJECT="$PROJECTID-$TARGETENV"
echo "[INFO]: creating: $TARGETPROJECT"

echo "[INFO]: creating workplace: mkdir -p oc_migration_scripts/migration_config"
mkdir -p oc_migration_scripts/migration_config
cd oc_migration_scripts
echo $(pwd)
url="https://$BITBUCKETHOST/projects/opendevstack/repos/ods-project-quickstarters/raw/ocp-templates/scripts/export_ocp_project_metadata.sh?at=refs%2Fheads%2Fproduction"
curl --fail -s --user $CRED -G $url -d raw -o export.sh
url="https://$BITBUCKETHOST/projects/opendevstack/repos/ods-project-quickstarters/raw/ocp-templates/scripts/import_ocp_project_metadata.sh?at=refs%2Fheads%2Fproduction"
curl --fail -s --user $CRED -G $url -d raw -o import.sh

cd migration_config
echo $(pwd)
url="https://$BITBUCKETHOST/projects/opendevstack/repos/ods-configuration/raw/ods-project-quickstarters/ocp-templates/scripts/ocp_project_config_source"
curl --fail -s --user $CRED -G $url -d raw -o ocp_project_config_source
url="https://$BITBUCKETHOST/projects/opendevstack/repos/ods-configuration/raw/ods-project-quickstarters/ocp-templates/scripts/ocp_project_config_target"
curl --fail -s --user $CRED -G $url -d raw -o ocp_project_config_target

cd ..
echo $(pwd)

gitUrl="https://$CRED@$BITBUCKETHOST/scm/$PROJECTID/$PROJECTID-occonfig-artifacts.git"
sh export.sh -p $PROJECTID -h $OPENSHIFTHOST -e $SOURCEENV -g $gitUrl -cpj -v true
sleep 5
sh import.sh -h $OPENSHIFTHOST -p $PROJECTID -e $SOURCEENV -g $gitUrl -n $TARGETPROJECT -v true --apply true
sleep 5

iterateBuildConfigs
#!/usr/bin/env bash

# This script sets up the cd/jenkins-master and the associated webhook proxy.

# support pointing to patched tailor using TAILOR environment variable
: ${TAILOR:=tailor}

tailor_exe=$(type -P ${TAILOR})
tailor_version=$(${TAILOR} version)

echo "Using tailor ${tailor_version} from ${tailor_exe}"

DEBUG=false
STATUS=false
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -p|--project)
    PROJECT="$2"
    shift # past argument
    ;;
    --status)
    STATUS=true
    ;;
    -d|--debug)
    DEBUG=true;
    shift
    ;;
    *)
    echo "Ignoring unknown option: $1"
    ;;
esac
shift # past argument or value
done

if $DEBUG; then
  tailor_verbose="-v"
else
  tailor_verbose=""
fi

if [ -z ${PROJECT+x} ]; then
    echo "PROJECT is unset, but required";
    exit 1;
else echo "PROJECT=${PROJECT}"; fi

if $STATUS; then
  echo "NOTE: Invoked with --status:  will use tailor status instead of tailor update."
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tailor_update_in_dir() {
    local dir="$1"; shift
    if [ ${STATUS} = "true" ]; then
        $DEBUG && echo 'exec:' cd  "$dir" '&&'
        $DEBUG && echo 'exec:'     ${TAILOR} $tailor_verbose status "$@"
        cd "$dir" && ${TAILOR} $tailor_verbose status "$@"
    else
        $DEBUG && echo 'exec:' cd "$dir" '&&'
        $DEBUG && echo 'exec:    ' ${TAILOR} $tailor_verbose --non-interactive update "$@"
        cd "$dir" && ${TAILOR} $tailor_verbose --non-interactive update "$@"
    fi
}

# create jenkins in the cd project
OCP_CONFIG="${SCRIPT_DIR}/../ocp-config/"

tailor_update_in_dir "${OCP_CONFIG}/cd-jenkins-master" \
    "--namespace=${PROJECT}-cd" \
    "--param=PROJECT=${PROJECT}" \
    --selector "template=cd-jenkins-master-template"

tailor_update_in_dir "${OCP_CONFIG}/cd-jenkins-master" \
    "--namespace=${PROJECT}-cd" \
    "--param=PROJECT=${PROJECT}" \
    --selector "template=cd-jenkins-webhook-proxy-template"

# add secrets for dockerfile build to dev and test
for devenv in dev test ; do
    tailor_update_in_dir "${OCP_CONFIG}/cd-user" \
        "--namespace=${PROJECT}-${devenv}"
done

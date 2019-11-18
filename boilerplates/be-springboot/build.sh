#!/bin/bash
SPRING_CLI_VERSION=2.2.1.RELEASE
JENKINS_SLAVE=cd/jenkins-slave-maven:latest

while [[ $# -gt 1 ]]
do
	key="$1"
	case $key in
		--registry)
		OCP_DOCKER_REGISTRY="$2"
		shift # past argument
		;;
		--user)
		OCP_DOCKER_REGISTRY_USER="$2"
		shift # past argument
		;;
		--token)
		OCP_DOCKER_REGISTRY_TOKEN="$2"
		shift # past argument
		;;
		*)
		# unknown option
		;;
	esac
shift # past argument or value
done

# change to directory of this script
cd $(dirname "$0")

sudo docker login \
  -u ${OCP_DOCKER_REGISTRY_USER} -p ${OCP_DOCKER_REGISTRY_TOKEN} ${OCP_DOCKER_REGISTRY}

sudo docker pull \
  ${OCP_DOCKER_REGISTRY}/${JENKINS_SLAVE}

sudo docker tag \
  ${OCP_DOCKER_REGISTRY}/${JENKINS_SLAVE} ${JENKINS_SLAVE}
  
sudo docker build \
  --rm \
  -t springboot:latest -t springboot:$SPRING_CLI_VERSION \
  --build-arg SPRING_CLI_VERSION=$SPRING_CLI_VERSION \
  .

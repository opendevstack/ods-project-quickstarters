#!/usr/bin/env bash

# assumption - you create a repo next to the others (copy from *sample) and make this your golden repo

configuration_location=../../../ods-configuration/ods-project-quickstarters/ocp-templates/templates/templates.env

if [[ ! -f $configuration_location ]]; then
	echo "Cannot find file: ${configuration_location} - please ensure you have copied ods-configuration-sample and created template.env"
	exit 1
fi

if ! oc whoami; then
    echo "You need to log into OpenShift first"
	exit 1
fi

source ${configuration_location}

cp ../templates/cd-jenkins-master.yml ../templates/cd-jenkins-master.yml.orig
cp ../templates/cd-jenkins-webhook-proxy.yml ../templates/cd-jenkins-webhook-proxy.yml.orig
cp ../templates/secrets.yml ../templates/secrets.yml.orig
cp ../templates/rshiny-app.yml ../templates/rshiny-app.yml.orig

sed -i.final -e "s|value: REPO_BASE|value: $REPO_BASE|g" ../templates/cd-jenkins-master.yml
sed -i.final -e "s|value: CD_USER_ID|value: $CD_USER_ID|g" ../templates/cd-jenkins-master.yml
sed -i.final -e "s|value: CD_USER_PWD|value: $CD_USER_PWD|g" ../templates/cd-jenkins-master.yml
sed -i.final -e "s|value: NEXUS_URL|value: $NEXUS_URL|g" ../templates/cd-jenkins-master.yml
sed -i.final -e "s|value: NEXUS_USERNAME|value: $NEXUS_USERNAME|g" ../templates/cd-jenkins-master.yml
sed -i.final -e "s|value: NEXUS_PASSWORD|value: $NEXUS_PASSWORD|g" ../templates/cd-jenkins-master.yml
sed -i.final -e "s|value: SONARQUBE_URL|value: $SONARQUBE_URL|g" ../templates/cd-jenkins-master.yml
sed -i.final -e "s|value: SONAR_SERVER_AUTH_TOKEN|value: $SONAR_SERVER_AUTH_TOKEN|g" ../templates/cd-jenkins-master.yml
sed -i.final -e "s|value: DOCKER_REGISTRY|value: $DOCKER_REGISTRY|g" ../templates/cd-jenkins-master.yml
sed -i.final -e "s|value: BITBUCKET_HOST|value: $BITBUCKET_HOST|g" ../templates/cd-jenkins-master.yml

sed -i.final -e "s|value: REPO_BASE|value: $REPO_BASE|g" ../templates/cd-jenkins-webhook-proxy.yml
sed -i.final -e "s|value: PIPELINE_TRIGGER_SECRET|value: $PIPELINE_TRIGGER_SECRET|g" ../templates/cd-jenkins-webhook-proxy.yml

sed -i.final -e "s|value: CD_USER_PWD|value: $CD_USER_PWD|g" ../templates/secrets.yml

sed -i.final -e "s|value: NEXUS_URL|value: $NEXUS_URL|g" ../templates/rshiny-app.yml
sed -i.final -e "s|value: NEXUS_USERNAME|value: $NEXUS_USERNAME|g" ../templates/rshiny-app.yml
sed -i.final -e "s|value: NEXUS_PASSWORD|value: $NEXUS_PASSWORD|g" ../templates/rshiny-app.yml
sed -i.final -e "s|value: CROWD_URL|value: $CROWD_URL|g" ../templates/rshiny-app.yml
sed -i.final -e "s|value: CROWD_RSHINY_REALM_USER|value: $CROWD_RSHINY_REALM_USER|g" ../templates/rshiny-app.yml
sed -i.final -e "s|value: CROWD_RSHINY_REALM_NAME|value: $CROWD_RSHINY_REALM_NAME|g" ../templates/rshiny-app.yml
sed -i.final -e "s|value: CROWD_RSHINY_REALM_PW|value: $CROWD_RSHINY_REALM_PW|g" ../templates/rshiny-app.yml


oc apply -n cd -f ../templates/cd-jenkins-master.yml
oc apply -n cd -f ../templates/cd-jenkins-webhook-proxy.yml
oc apply -n cd -f ../templates/component-environment.yml
oc apply -n cd -f ../templates/component-route.yml
oc apply -n cd -f ../templates/bc-docker.yml
oc apply -n cd -f ../templates/secrets.yml
oc apply -n cd -f ../templates/rshiny-app.yml

mv ../templates/cd-jenkins-master.yml.orig ../templates/cd-jenkins-master.yml
mv ../templates/cd-jenkins-webhook-proxy.yml.orig ../templates/cd-jenkins-webhook-proxy.yml
mv ../templates/secrets.yml.orig ../templates/secrets.yml
mv ../templates/rshiny-app.yml.orig ../templates/rshiny-app.yml

rm -f ../templates/*.final

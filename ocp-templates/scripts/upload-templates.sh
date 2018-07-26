#!/usr/bin/env bash

# assumption - you create a repo next to the others (copy from *sample) and make this your golden repo

configuration_location=../../ods-configuration/ocp-templates/templates/templates.env

if [[ ! -f $configuration_location ]]; then
	echo "Cannot find file: ${configuration_location} - please ensure you have copied ods-configuration-sample and created template.env"
	exit 1
fi

source ${configuration_location}

cp ../templates/cd-jenkins-persistent.yml ../templates/cd-jenkins-persistent.yml.orig
cp ../templates/secrets.yml ../templates/secrets.yml.orig

sed -i.final -e "s|value: REPO_BASE|value: $REPO_BASE|g" ../templates/cd-jenkins-persistent.yml
sed -i.final -e "s|value: CD_USER_ID|value: $CD_USER_ID|g" ../templates/cd-jenkins-persistent.yml
sed -i.final -e "s|value: CD_USER_PWD|value: $CD_USER_PWD|g" ../templates/cd-jenkins-persistent.yml
sed -i.final -e "s|value: NEXUS_URL|value: $NEXUS_URL|g" ../templates/cd-jenkins-persistent.yml
sed -i.final -e "s|value: SONARQUBE_URL|value: $SONARQUBE_URL|g" ../templates/cd-jenkins-persistent.yml
sed -i.final -e "s|value: SONAR_SERVER_AUTH_TOKEN|value: $SONAR_SERVER_AUTH_TOKEN|g" ../templates/cd-jenkins-persistent.yml
sed -i.final -e "s|value: CD_USER_PWD|value: $CD_USER_PWD|g" ../templates/secrets.yml

oc apply -n cd -f ../templates/cd-jenkins-persistent.yml
oc apply -n cd -f ../templates/component-environment.yml
oc apply -n cd -f ../templates/component-route.yml
oc apply -n cd -f ../templates/component-pipeline.yml
oc apply -n cd -f ../templates/bc-docker.yml
oc apply -n cd -f ../templates/secrets.yml
oc apply -n cd -f ../templates/rshiny-app.yml

mv ../templates/cd-jenkins-persistent.yml.orig ../templates/cd-jenkins-persistent.yml
mv ../templates/secrets.yml.orig ../templates/secrets.yml

rm -f ../templates/*.final

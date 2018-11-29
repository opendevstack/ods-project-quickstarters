#!/usr/bin/env bash
# This script creates the 3 OCP projects we currently require for every
# OD project.
# * project-cd  : containing jenkins
# * project-dev : dev environment based on feature branch
# * project-test: test environment based on master branch

# Use -gt 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use -gt 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to -gt 0 the /etc/hosts part is not recognized ( may be a bug )
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -p|--project)
    PROJECT="$2"
    shift # past argument
    ;;
    -u|--cd_user)
    CD_USER="$2"
    shift # past argument
    ;;
    -w|--cd_pwd)
    CD_USER_PWD="$2"
    shift # past argument
    ;;
	-a|--project_admins)
    OD_PRJ_ADMINS="$2"
    shift # past argument
    ;;    
    -n|--nexus)
    NEXUS_HOST="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

# check required parameters
if [ -z ${PROJECT+x} ]; then
    echo "PROJECT is unset";
    exit 1;
else echo "PROJECT=${PROJECT}"; fi

if [ -z ${NEXUS_HOST+x} ]; then
    echo "NEXUS is unset";
    exit 1;
else echo "NEXUS_HOST=${NEXUS_HOST}"; fi

oc new-project ${PROJECT}-cd
oc new-project ${PROJECT}-dev
oc new-project ${PROJECT}-test

# set admin permissions for Jenkins on the project(s)
## remark: 'edit' role may be sufficient but in case the pipeline needs to do more advanced tasks, 'admin' may be required

JENKINS_ROLE=admin

oc policy add-role-to-user ${JENKINS_ROLE} system:serviceaccount:${PROJECT}-cd:jenkins -n ${PROJECT}-dev
oc policy add-role-to-user ${JENKINS_ROLE} system:serviceaccount:${PROJECT}-cd:jenkins -n ${PROJECT}-test

# allow default project user to modify build configs in dev and test
oc policy add-role-to-user edit system:serviceaccount:${PROJECT}-cd:default -n ${PROJECT}-dev
# cut - default (cd) user needs admin rights to pull secrets during project clone
oc policy add-role-to-user admin system:serviceaccount:${PROJECT}-cd:default -n ${PROJECT}-test
oc policy add-role-to-user edit system:serviceaccount:${PROJECT}-cd:default -n ${PROJECT}-cd

# allow jenkins in <project>-cd to pull images (e.g. slave) from cd project
oc policy add-role-to-user system:image-puller system:serviceaccount:${PROJECT}-cd:jenkins -n cd
oc policy add-role-to-user system:image-puller system:serviceaccount:${PROJECT}:default -n cd

# not really needed, because we build an image directly on master again, no pulling
oc policy add-role-to-group system:image-puller system:serviceaccounts:${PROJECT}-test -n $PROJECT-dev

# allow all authenticated users to access and view the project
oc policy add-role-to-group view system:authenticated -n $PROJECT-dev
oc policy add-role-to-group view system:authenticated -n $PROJECT-test
oc policy add-role-to-group view system:authenticated -n $PROJECT-cd
oc policy add-role-to-group edit system:authenticated -n $PROJECT-dev
oc policy add-role-to-group edit system:authenticated -n $PROJECT-test
oc policy add-role-to-group edit system:authenticated -n $PROJECT-cd
oc policy add-role-to-group basic-user system:authenticated -n $PROJECT-dev
oc policy add-role-to-group basic-user system:authenticated -n $PROJECT-test
oc policy add-role-to-group basic-user system:authenticated -n $PROJECT-cd

# seed admins, by default only role dedicated-admin has admin rights
if [[ ! -z ${OD_PRJ_ADMINS} ]]; then 
	for admin_user in $(echo $OD_PRJ_ADMINS | sed -e 's/,/ /g');
	do		
		echo "- seeding admin: ${admin_user}"
		oc policy add-role-to-user admin ${admin_user} -n ${PROJECT}-dev
		oc policy add-role-to-user admin ${admin_user} -n ${PROJECT}-test
		oc policy add-role-to-user admin ${admin_user} -n ${PROJECT}-cd
	done
fi

# create jenkins in the cd project
oc process cd//cd-jenkins-master | oc create -f- -n ${PROJECT}-cd
oc process cd//cd-jenkins-webhook-proxy | oc create -f- -n ${PROJECT}-cd

# add secrets for dockerfile build to dev and tes
oc process cd//secrets PROJECT=${PROJECT} | oc create -f- -n ${PROJECT}-dev
oc process cd//secrets PROJECT=${PROJECT} | oc create -f- -n ${PROJECT}-test

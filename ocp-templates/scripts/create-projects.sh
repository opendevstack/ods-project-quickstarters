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
	-e|--project_entitlements)
    OD_PRJ_ENTL_GROUPS="$2"
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

# set admin permissions for the Jenkins SA on the project(s)
# this is needed to clone an entire project including role bindings for autocloneEnv in the shared lib 

JENKINS_ROLE=admin

# allow jenkins from CD project to admin the environment projects
oc policy add-role-to-user ${JENKINS_ROLE} system:serviceaccount:${PROJECT}-cd:jenkins -n ${PROJECT}-dev
oc policy add-role-to-user ${JENKINS_ROLE} system:serviceaccount:${PROJECT}-cd:jenkins -n ${PROJECT}-test

# allow jenkins in <project>-cd to pull images (e.g. slave) from cd project
oc policy add-role-to-user system:image-puller system:serviceaccount:${PROJECT}-cd:jenkins -n cd

# allow webhook proxy to create a pipeline BC in the +cd project
oc policy add-role-to-user edit -z default -n ${PROJECT}-cd

# seed jenkins SA with edit roles in CD project / to even run jenkins
oc policy add-role-to-user edit -z jenkins -n ${PROJECT}-cd

# allow test users to pull dev images
oc policy add-role-to-group system:image-puller system:serviceaccounts:${PROJECT}-test -n $PROJECT-dev

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

if [[ ! -z ${OD_PRJ_ENTL_GROUPS} ]]; then 
	echo "seeding special permission groups"
	for group in $(echo $OD_PRJ_ENTL_GROUPS | sed -e 's/,/ /g');
	do		
		groupName=$(echo $group | cut -d "=" -f1)
		groupValue=$(echo $group | cut -d "=" -f2)
		
		usergroup_role=edit
		admingroup_role=admin
		readonlygroup_role=view
		
		if [[ ${groupValue} == "" ]];
		then
			continue
		fi
		
		echo "- seeding groups: ${groupName^^} - ${groupValue}"
		if [[ ${groupName^^} == *USERGROUP* ]]; then
			oc policy add-role-to-group ${usergroup_role} ${groupValue} -n ${PROJECT}-dev
			oc policy add-role-to-group ${usergroup_role} ${groupValue} -n ${PROJECT}-test
			oc policy add-role-to-group ${usergroup_role} ${groupValue} -n ${PROJECT}-cd
		elif [[ ${groupName^^} == *ADMINGROUP* ]]; then 
			oc policy add-role-to-group ${admingroup_role} ${groupValue} -n ${PROJECT}-dev
			oc policy add-role-to-group ${admingroup_role} ${groupValue} -n ${PROJECT}-test
			oc policy add-role-to-group ${admingroup_role} ${groupValue} -n ${PROJECT}-cd
		elif [[ ${groupName^^} == *READONLYGROUP* ]]; then
			oc policy add-role-to-group ${readonlygroup_role} ${groupValue} -n ${PROJECT}-dev
			oc policy add-role-to-group ${readonlygroup_role} ${groupValue} -n ${PROJECT}-test
			oc policy add-role-to-group ${readonlygroup_role} ${groupValue} -n ${PROJECT}-cd
		fi
	done
else
	echo "- seeding default edit/view rights for system:authenticated"
	oc policy add-role-to-group edit system:authenticated -n $PROJECT-dev
	oc policy add-role-to-group edit system:authenticated -n $PROJECT-test
	oc policy add-role-to-group edit system:authenticated -n $PROJECT-cd
	
	# allow all authenticated users to view the project
	oc policy add-role-to-group view system:authenticated -n $PROJECT-dev
	oc policy add-role-to-group view system:authenticated -n $PROJECT-test
	oc policy add-role-to-group view system:authenticated -n $PROJECT-cd	
fi

# create jenkins in the cd project
oc process cd//cd-jenkins-master | oc create -f- -n ${PROJECT}-cd
oc process cd//cd-jenkins-webhook-proxy | oc create -f- -n ${PROJECT}-cd

# add secrets for dockerfile build to dev and tes
oc process cd//secrets PROJECT=${PROJECT} | oc create -f- -n ${PROJECT}-dev
oc process cd//secrets PROJECT=${PROJECT} | oc create -f- -n ${PROJECT}-test

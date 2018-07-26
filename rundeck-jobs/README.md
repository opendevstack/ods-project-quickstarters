Repository for Rundeck jobs

a) create a branch called rundeck-changes from master
b) create a new project called quickstarts

add / change the below global project settings
project.globals.bitbucket_host=<your bitbucket repository url, eg: https://github.com>
project.globals.bitbucket_sshhost=<your bitbucket repository url, eg: ssh\://git@github.com\:7999>
project.globals.nexus_host=<nexus host url>
project.globals.openshift_apihost=<openshift API host url>
project.globals.rundeck_os_user=<rundeck OS user incl group e.g. rundeck:rundeck>

c) configure scm import against this repository - against branch rundeck-changes pattern *.yaml
d) disable scm import, and configure scm export - ensure the file path does NOT contain rundeck directory
	File Path Template: ${job.group}${job.name}.${config.format} 



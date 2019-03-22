# Rundeck jobs

## Introduction 
This folder contains all job definitions used by Rundeck. They are mainly used for provisioniong components and projects, and triggered by the [provision application](https://github.com/opendevstack/ods-provisioning-app)

## Setup / installation of jobs into rundeck

1. clone this repo and create a branch called rundeck-changes from master - push into your bitbucket
1. in Rundeck create a new project called `quickstarts`
   1. add / change the below parameters in the project's settings<br>
   ``` 
   project.globals.bitbucket_host=<your bitbucket repository url, eg: https://github.com>
   project.globals.bitbucket_sshhost=<your bitbucket repository url, eg: ssh\://git@github.com\:7999><br>
   project.globals.nexus_host=<nexus host url>
   project.globals.openshift_apihost=<openshift API host url>
   project.globals.rundeck_os_user=<rundeck OS user incl group e.g. rundeck:rundeck>
   project.globals.openshift_dockerregistry=<registry host without protocol and port>
   project.globals.openshift_user=<user that has pull rights against the internal registry> 
   ``` 
1. configure the scm import plugin against this repository - against branch `rundeck-changes` with pattern `*.yaml`
1. disable scm import, and configure scm export - ensure the file path does NOT contain rundeck directory <br>
	`File Path Template`: `${job.group}${job.name}.${config.format}` 

More details on the overall installation process can be found in the [install guide](http://www.opendevstack.org/doc/getting-started.html) 

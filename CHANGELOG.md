# Changelog

## 0.1.0 (2018-07-27)

Initial release.

## 0.2.0RC *current master*

1. Overall changes in architecture
   1. Quickstarter build containers (located in the subdirs of https://github.com/opendevstack/ods-project-quickstarters/tree/master/boilerplates) inherit from corresponding jenkins build slaves now rather than replicating the setup
   1. Rundeck's OC container inherits from jenkins-slave-base now. The pull and tag is triggered thru *verify-rundeck-settings* rundeck job (#32)
   1. The build of a quickstarter component does not upload the tarball to nexus anymore - instead it uses binary build configs (#9). The shared library will patch old BCs automatically, when taken up.
   1. The containers used to connect to openshift now pull the root ca during build, to ensure SSL trust (#12)
   
1. Slave specifics
   1. Python slave upgraded to 3.7 (#24)
   1. Maven slave now downloads Gradle 4.8.1 during build to increase build performance of components (#23)
   1. Scala slave now downloads sbt 1.1.6 / scala 2.12 

1. Others (bugfixes)
   1. Nodejs 8 quickstarter failed on npm run coverage (#22)
   1. Rundeck containers not cleaned up (#16, #17)




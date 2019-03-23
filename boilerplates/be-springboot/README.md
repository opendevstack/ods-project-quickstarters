# Spring Boot Quickstarter

## Purpose of this quickstarter
Use this quickstarter to generate a [spring boot](https://www.tutorialspoint.com/spring_boot/index.htm) based project.

It will provide a java 8 project with preconfigured gradle build and CI/CD integration (Jenkinsfile).

## What files / architecture is generated?
Under the hook this quickstarter runs the [spring boot cli init command](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#cli-init).

This is implemented in the script ```init.sh``` (open it to understand the internal of the code generation of this quickstarter).

When provisioning this quickstarter in the provisioning app a spring boot project will be generated and pushed to your git repository.

The generated project requires java 8 and include the required gradle build and wrapper artifact.

#####Project Structure
The generated spring boot project contains following folders:
+ ```src``` (maven based java project structure)
+ ```gradle``` (gradle wrapper portable distribution)
+ ```docker``` (include the ```Dockerfile``` used to build the image to be deployed during CI/CD to openshift)

#####Gradle Support
The generated project includes a gradlew wrapper which is a portable distribution of gradle.
It allows you to easily build the project without any further tool installation other than java.    

You´ll find in the project following gradle artifacts:
+ ```build.gradle``` (build definition)
+ ```gradlew.bat```
+ ```gradlew```
+ ```gradle/wrapper/gradle-wrapper.jar```
+ ```gradle/wrapper/gradle.properties```
+ ```settings.gradlew```

NOTE: gradle.properties is missing. This is on purpose. You´ll need to create it yourself and add following properties:
+ ```nexus_url=<URL_OF_YOUR_NEXUS_SERVER>```
+ ```nexus_folder=<FOLDER_TO_UPLOAD_ARTIFACTS>``` (ie. snapshots, candidate)
+ ```nexus_user=<YOUR_NEXUS_USERNAME>```
+ ```nexus_pw=<YOUR_NEXUS_PASSWORD>```

The quickstarter uses the latest available spring boot cli version to generate the spring boot project.

Run ```gradlew -v``` to verify the installed version of gradle wrapper.

#####Dependencies and Frameworks used
The generated spring boot project is preconfigured with some third party dependencies (i.e. ```--dependencies="web,jersey,data-jpa,h2,lombok,data-rest,restdocs,security"```), which are defined in the script ```init.sh``` (open it to understand the internal of the code generation of this quickstarter).

Look in method ```dependencies``` in the file ```build.gradle``` to review the defined dependencies.   

#####ODS Integration (Jenkinsfile)
The project includes a special artifact that enables it to integrate with OpenDevStack CI/CD infrastructure.
The ```Jenkinsfile``` provides this capability.
Basically it is the script that is executed in Jenkins every time a push to your git repository is done. More on this below.

## Usage - how do you start after you provisioned this quickstarter
After the provisioning the provisioning app will display the url of git repository.
This git repository contains the generated project artifacts as describe above in [Project Structure](#project-structure). 

To start working with it you´ll need to clone the git repository in your local development environment.
After cloning it use ```./gradlew build``` to verify that the project compiles and test runs.

NOTE: java 8 or later version is required to run gradlew and compile java classes.     

## How this quickstarter is built thru jenkins
The ```Jenkinsfile``` implements the CI/CD pipeline of your project.

The ```Jenkinsfile``` is kind of configuration that customizes the core pipeline implemented by [jenkins shared library](https://github.com/opendevstack/ods-jenkins-shared-library).
It is highly recommended that you familiarize with this file and library.
 
It is executed in Jenkins every time a push to your git repository is done.
Basically, the tasks implemented by this pipeline are:
1. clone the branch in the Jenkins environment
1. run the java build
1. build a docker image
1. deploy the docker image to openshift

NOTE: The 2nd step executes ```gradlew build``` to compile your project and create a distribution as ```jar``` file. 
This file is copied to the ```docker``` folder to be included in the docker image when the image is built in step 3.  

## Builder Slave used

This quickstarter uses
[Maven builder slave](https://github.com/opendevstack/ods-project-quickstarters/tree/master/jenkins-slaves/maven) Jenkins builder slave.

## Known limitations

NA
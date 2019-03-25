# Rshiny Application
## Purpose of this quickstarter
Provisions a Rshiny application within openshift using crowd authentification.

## What files / architecture is generated?
+-- Jenkinsfile  
+-- Dockerfile    
+-- app.R

## Frameworks used
R/Rshiny

## Usage - how do you start after you provisioned this quickstarter
The quickstarter sets up two pods in openshift. The rshiny application is routed through a crowd authentication proxy.


## How this quickstarter is built through jenkins
The build pipeline is defined in the `Jenkinsfile` in the project root. The main stages of the pipeline are:
2. Start openshift build
3. Deploy image to openshift

## Builder slave used
[jenkins-slave-base](https://github.com/opendevstack/ods-core/tree/master/jenkins/slave-base)

## Known limitions
N/A

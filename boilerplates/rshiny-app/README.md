# Rshiny Application
## Purpose of this quickstarter
Provisions a Rshiny application within openshift using crowd authentification.

## What files / architecture is generated?
+-- Jenkinsfile  
+-- Dockerfile    
+-- app.R

## Frameworks used
[R](https://www.tutorialspoint.com/r/index.htm)/[Rshiny](https://shiny.rstudio.com/tutorial/)

## Usage - how do you start after you provisioned this quickstarter
The quickstarter sets up two pods in openshift. The rshiny application is routed through a [crowd authentication proxy](https://github.com/opendevstack/ods-core/tree/master/shared-images/nginx-authproxy-crowd).


## How this quickstarter is built through jenkins
The build pipeline is defined in the `Jenkinsfile` in the project root. The main stages of the pipeline are:
2. Start openshift build
3. Deploy image to openshift

## Builder slave used
[jenkins-slave-base](https://github.com/opendevstack/ods-core/tree/master/jenkins/slave-base)

## Known limitions
N/A

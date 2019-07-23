# Frontend react.js (fe-react)

React quickstarter project

For pull requests and discussion regarding direction, please pull in @velcrin, @m-apsolon


## Purpose of this quickstarter

This quickstarter generates a React project for developing web pages using [Create React App](https://facebook.github.io/create-react-app/).

It contains the basic setup for [Docker](https://www.docker.com/), [Jenkins](https://jenkins.io/), [SonarQube](https://www.sonarqube.org/) and [OpenShift](https://www.openshift.com/), so you have your CI/CD process out of the box.

## What files / architecture is generated?

Please, refer to Create React App [file structure](https://facebook.github.io/create-react-app/docs/folder-structure) for more details.

## Usage - how do you start after you provisioned this quickstarter

As pre-requisite you'll need to have installed:

* [node](https://nodejs.org/en/download/)
* npm which is bundled with the node installation
* [git](https://git-scm.com/downloads) 


Once you have you developer environment set up you can simply:

* Clone your generated git repository and `cd` to your folder
* Run command `npm install` in project directory to install npm dependencies.
* Run `npm start` command to start the dev server, it will open your browser at `http://localhost:8080/`


 ## How this quickstarter is built thru Jenkins

 The `Jenkinsfile` contains the configuration that customizes the core pipeline implemented by [jenkins shared library](https://github.com/opendevstack/ods-jenkins-shared-library).

 When the code in your git repository is updated the `Jenkinsfile` comes into action with the following stages for this quickstarter:

   * **Build** - Installs the dependencies of your project with `npm ci`, generates the build by running `npm run build`. Finally, it copies the output folder `build` into `docker/dist`.

   * **Unit Test** - Runs unit test cases by executing `npm test` command, if any test fails, the build is marked as failed.


 ## Builder Slave used 

This quickstarter uses [Nodejs8-Angular builder slave](https://github.com/opendevstack/ods-project-quickstarters/tree/master/jenkins-slaves/nodejs8-angular) Jenkins builder slave.

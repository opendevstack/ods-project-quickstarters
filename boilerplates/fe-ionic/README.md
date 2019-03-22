# Frontend Ionic (fe-ionic)

Ionic quickstarter project

## Purpose of this quickstarter

This quickstarter generates an Ionic 3 project, you can use it when you want to develop a cross platform app (iOS, android and PWA) in one codebase using Web technologies like CSS, HTML and JavaScript/Typescript.

It contains the basic setup for [Docker](https://www.docker.com/), [Jenkins](https://jenkins.io/), [SonarQube](https://www.sonarqube.org/) and [OpenShift](https://www.openshift.com/), so you have your CI/CD process out of the box.


## What files / architecture is generated?

The files are generated using [Ionic CLI](https://ionicframework.com/docs/cli/). It scaffolds a tabbed app containing 3 basic pages (home, about and contact).

```
.
├── Jenkinsfile - This file contains Jenkins build configuration settings
├── README.md
├── config - This folder contains Webpack and sass configuration settings
├── docker - This folder contains Docker configuration settings
│   ├── Dockerfile
│   └── nginx.vh.default.conf.nginx
├── e2e
│   ├── test.e2e-specs.ts
│   └── tsconfig.json
├── resources - This folder contains resources by platform ios, android
├── package.json - This file contains scripts to run and node packages dependencies for project
├── sonar-project.properties - This file contains SonarQube configuration settings
├── src
│   ├── app
│   │   ├── app.component.ts
│   │   ├── app.html
│   │   ├── app.module.ts
│   │   ├── app.scss
│   │   └── main.ts
│   ├── assets
│   ├── environments
│   │   ├── environment.dev.ts
|   |   |__ environment.e2e.ts
│   │   └── environment.ts
│   ├── pages
│   ├── providers
│   ├── theme
│   ├── index.html
│   ├── manifest.json
│   ├── polyfills.ts
│   ├── service-worker.js
│   ├── test.ts
│   └── tsconfig.spec.json
├── www
├── .angular-cli.json - This file contains Angular project configuration settings
├── config.xml - This file contains config settings for your mobile app, like package name and native preferences
├── .ionic.config.json - This file contains Ionic project configuration 
├── karma.conf.js
├── protractor.conf.js
├── tsconfig.json
└── tslint.json
```

## Frameworks used

* [Ionic CLI](https://ionicframework.com/docs/cli/)
* [Ionic Framework](https://ionicframework.com/docs/v3/)
* [Angular](https://angular.io/)
* [Typescript](http://www.typescriptlang.org/)


## Usage - how do you start after you provisioned this quickstarter

As pre-requisite you'll need to have installed:

* [node](https://nodejs.org/en/download/)
* npm which is bundled with the node installation
* [git](https://git-scm.com/downloads) 
* Ionic CLI globally in your local environment by running: `npm install -g ionic`


Once you have you developer environment set up you can simply:

* Clone your generated git repository and `cd` to your folder
* Run command `npm install` in project directory to install npm dependencies.
* Run `ionic serve` command to start the dev server, it will open your browser at `http://localhost:8100/`


To develop an **iOS** application, you'll need to setup your developer environment as suggested in this [guide](https://ionicframework.com/docs/installation/ios).

For **android** support configure your environment like this [guide](https://ionicframework.com/docs/installation/android).


## How this quickstarter is built thru Jenkins

The `Jenkinsfile` contains the configuration that customizes the core pipeline implemented by [jenkins shared library](https://github.com/opendevstack/ods-jenkins-shared-library).

When the code in your git repository is updated the `Jenkinsfile` comes into action with the following stages for this quickstarter:

  * **Build** - Installs the dependencies of your project with `yarn install`, generates the build by running `npm run ionic:build`, if the merged git branch is master it creates the production build with `npm run ionic:build --prod`. Finally, it copies the output folder `www` into `docker/dist`.

  * **Unit Test** - Runs unit test cases by executing `yarn test` command, if any test fails, the build is marked as failed.

  * **Lint** - Profiler that ensures code best practices by running `npm run lint` command, if linting is not passing, the build is marked as failed also.


## Builder Slave used 

This quickstarter uses
[Nodejs8-Angular builder slave](https://github.com/opendevstack/ods-project-quickstarters/tree/master/jenkins-slaves/nodejs8-angular) Jenkins builder slave.


## Known Limitation

Ionic Pro builds needs to be configured separately as described [here](https://github.com/opendevstack/ods-project-quickstarters/blob/5da91c9d190b0eb96bf53b393e355e355e18bfdf/boilerplates/fe-ionic/files/README.md)

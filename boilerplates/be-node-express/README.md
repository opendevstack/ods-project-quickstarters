# Backend Node (be-node-express)

## Purpose of this quickstarter (use this when you want to ...)
This is a node (v6) quick starter with express using typescript. 
If you are doing non-blocking operation and does not have heavy algorithm/Job which consumes lots of CPU power, this could be an ideal fit.
It contains the basic setup for [Docker](https://www.docker.com/), [Jenkins](https://jenkins.io/), [SonarQube](https://www.sonarqube.org/) and [OpenShift](https://www.openshift.com/).

## What files / architecture is generated?
The files are generated using a [yeoman](https://yeoman.io/) generator for [node-express-typescript](https://www.npmjs.com/package/generator-node-express-typescript). Generated files include a minimal express server with dummy routes.
```
├── Jenkinsfile - Contains Jenkins build configuration 
├── LICENSE
├── README.md
├── docker - Contains Dockerfile for the build
│   └── Dockerfile
├── package-lock.json - Commit this file you update your dependencies
├── package.json - This file contains all the npm dependencies and build commands for the project.
├── sonar-project.properties  - SonarQube Configuration
├── src
│   ├── greeter.ts
│   ├── index.ts -  Entrypoint, This runs first
│   └── routes
│       └── weather.ts
├── test
│   ├── greeter-spec.ts
│   └── index-spec.ts
├── tsconfig.json - TypeScript Configuration file
└── tslint.json - TypeScript Linter Configuration
4 directories, 14 files
```

## Frameworks used
1.  [Express (^4.15)](https://expressjs.com/)
2.  [Mocha](https://mochajs.org/) & [Chai](https://www.chaijs.com/) for Unit Testing
3.  [Typescript](http://www.typescriptlang.org/)

## Usage - how do you start after you provisioned this quickstarter
1. Do a `npm install` form the project root to install all the dependencies.
2. `npm run serve` will transpile the code and start the server
3. Execute `npm run test` for unit testing

## How this quickstarter is built thru jenkins
The build pipeline is defined in the `Jenkinsfile` in the project root. The mains stages of the pipeline are, 
1.  Build :  `npm run build` command will be executed to build the application and then the build (including the node_modules) will be copied to the `docker/dist` folder. 
2.  Unit Testing : `npm test -- --progress false` & `npm run coverage` commands will be executed for running unit tests and to generate coverage report. The results can be seen form the jenkins console output.

## Builder Slave used 
This quickstarter uses
[Nodejs8-Angular builder slave](https://github.com/opendevstack/ods-project-quickstarters/tree/master/jenkins-slaves/nodejs8-angular) Jenkins builder slave.

## Known limitations
N/A

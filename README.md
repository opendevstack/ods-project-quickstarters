# ODS Quickstarters

## Overview

This repository contains quickstarters, which are basically templates that help to start out with a component quickly. The available quickstarters are:

- [Backend - Java/SpringBoot](https://github.com/opendevstack/ods-project-quickstarters/blob/master/boilerplates/be-springboot/README.md)
- [Backend - Python/Flask](https://github.com/opendevstack/ods-project-quickstarters/blob/master/boilerplates/be-python-flask/README.md)
- [Backend - Scala/Akka](https://github.com/opendevstack/ods-project-quickstarters/blob/master/boilerplates/be-scala-akka/README.md)
- [Backend - NodeJS/Express](https://github.com/opendevstack/ods-project-quickstarters/blob/master/boilerplates/be-node-express/README.md)
- [Frontend - Angular](https://github.com/opendevstack/ods-project-quickstarters/blob/master/boilerplates/fe-angular/README.md)
- [Frontend - React](https://github.com/opendevstack/ods-project-quickstarters/blob/master/boilerplates/fe-react/README.md)
- [E2E test - Cypress](https://github.com/opendevstack/ods-project-quickstarters/blob/master/boilerplates/e2e-cypress/README.md)
- [Mobile - Ionic](https://github.com/opendevstack/ods-project-quickstarters/blob/master/boilerplates/fe-ionic/README.md)
- [Data Science - Machine Learning](https://github.com/opendevstack/ods-project-quickstarters/blob/master/boilerplates/ds-ml-service/README.md)
- [Data Science - Jupyter Notebook](https://github.com/opendevstack/ods-project-quickstarters/blob/master/boilerplates/jupyter-notebook/README.md)
- [Data Science - R-Shiny](https://github.com/opendevstack/ods-project-quickstarters/blob/master/boilerplates/rshiny/README.md)

Next to those, there is a ["blank" quickstarter](https://github.com/opendevstack/ods-project-quickstarters/blob/master/boilerplates/be-docker-plain/README.md) allowing to start from scratch, while still providing all the OCP resources / Jenkins / SonarQube conveniences described in the following sections.

All quickstarters are used by the [provisioning app](https://github.com/opendevstack/ods-provisioning-app) to create a new component which basically consists of resources in OpenShift (typically `BuildConfig`, `ImageStream`, `DeploymentConfig` and `Service`) and a BitBucket repository.

This repository in BitBucket will contain:

- Some boilerplate code
- A `Jenkinsfile` describing how to build the component, delegating most of the work to the [shared library](https://github.com/opendevstack/ods-jenkins-shared-library)
- A `sonar-project.properties` file configuring how the source code is analyzed by SonarQube

Next to those, each quickstarter can also provide its own [Jenkins slave images](https://github.com/opendevstack/ods-project-quickstarters/tree/master/jenkins-slaves).


## Usage

The quickstarters are not used directly, but triggered via the [provisioning app](https://github.com/opendevstack/ods-provisioning-app). Login there to pick
a quickstarter, give it a name and provision it. The provisioning app delegates the executation to a
job in Rundeck (defined in YML files in the [rundeck](rundeck) folder), which then clones this repository and executes the files (e.g. `init.sh`) within.


## Changing existing quickstarters

As the quickstarters are triggered via Rundeck, the changes need to be on the `production` branch in order to be "live". As an alternative, you can copy the job in Rundeck and point it to the branch you
are working on.

To test out things locally, you can mimick what Rundeck. The general procedure is:

1. Clone the repository
2. Go into a quickstarter folder, e.g. `be-node-express`
3. Run `build.sh` (if it exists)
4. Run `init.sh`
5. Run `renderJenkinsTemplate.sh` from the root of the repository
6. Run `renderSonarqubeTemplate.sh` from the root of the repository

Note that those scripts might need parameters to work, and often need to be adjusted slightly to work (e.g. removing `chown`ing to `rundeck` user).


## Upgrade an existing Git repository to OpenDevStack

Push your repository into the newly created bitbucket project (and note the name of the repo & project)

Logon to rundeck and pick the `common/prepare-continuous-integration` rundeck job

1. Pick the technology target thru `component type` - this will ensure you get the right jenkins file based on the technology you pick - and should fit the technology you have built your application with
2. Provide `quickstarter_directory` - this can be any filesystem directory - usually in `/tmp/<component name>` where the git repository will be cloned to 
3. Provide `project_id` - this is the project name you noted in step (0)
4. Provide `component_id`- this is the name of the component (from step 0) that will be rendered into the jenkins template, and also used as name for the openshift resources
5. Provide `git_url_http/ssh` - this is the URL to clone and commit to for the job.

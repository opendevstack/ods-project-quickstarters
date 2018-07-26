# Overview

This repository contains quickstarters, which are basically templates that help to start out with a component quickly. Available components include e.g. Spring Boot, Akka or Angular.

# Usage

The quickstarters are not used directly, but triggered via the provisioning app, which in turn triggers a job in Rundeck (defined in `rundeck` folder), which then uses the files in this repository.

# Development

As the quickstarters are triggered via Rundeck, the changes need to be on the production branch in order to be "live". It is possible however to mimick what Rundeck does locally.

The general procedure is:

1. Clone the repository
2. Go into a quickstarter folder, e.g. `be-node-express`
3. Run `build.sh`
4. Run `init.sh`
5. Run `renderJenkinsTemplate.sh` from the root of the repository
6. Run `renderSonarqubeTemplate.sh` from the root of the repository

Note that those scripts might need parameters to work, and often need to be adjusted slightly to work (e.g. removing `chown`ing to `rundeck` user).

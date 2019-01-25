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

# Upgrade an existing GIT repository to ODS

Push your repository into the newly created bitbucket project (and note the name of the repo & project)

Logon to rundeck and pick the `common/prepare-continuous-integration` rundeck job

1. Pick the technology target thru `component type` - this will ensure you get the right jenkins file based on the technology you pick - and should fit the technology you have built your application with
2. Provide `quickstarter_directory` - this can be any filesystem directory - usually in `/tmp/<component name>` where the git repository will be cloned to 
3. Provide `project_id` - this is the project name you noted in step (0)
4. Provide `component_id`- this is the name of the component (from step 0) that will be rendered into the jenkins template, and also used as name for the openshift resources
5. Provide `git_url_http/ssh` - this is the URL to clone and commit to for the job.

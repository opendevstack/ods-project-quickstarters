# Plain Dockerfile-based quickstarter

## Overview
This quickstarter provides the most simple way to plug into OpenDevStack CI/CD. It only contains a `Dockerfile` that one should adapt to ones needs.

## Customization

* For unit testing, add your tests to the repository and amend `stageUnitTest`
* For code analysis, add the stage `stageScanForSonarqube` and amend `sonar-project.properties`

## Image build process

The most important stage is `stageBuild`. Here you can copy any artifacts into the `docker` directory - which is the context passed into the image build process. Whatever is in this context you can use from within the `Dockerfile` via `COPY` instructions.

In case your `Dockerfile`'s `FROM` refers to an imagestream in your OpenShift registry, you need to alter the `BuildConfig` and provide the imagestream/name to build from.


# Plain dockerfile based quickstarter

## Introduction
This quickstarter provides the most simple way to plug into the OpenDevStack CI/CD.

It 'only' contains a `dockerFile` that one should adapt to his/her needs.
In case you want to do unit testing during build, add your tests to the project and amend `stageUnitTest`, for sources you can plug into the stage `stageScanForSonarqube` and amend the `sonar-project.properties`

The most important stage is `stageBuild`. Here you can copy any artifacts to `$HOME/docker` - which is the context passed into the build. Whatever is in this context you can use from within the `dockerFile` thru `ADD` or `COPY`.  

## Important
In case your dockerFile's `FROM` refers to an imagestream /image that was built on openshift, which does not originate from github / or the public openshift registry, you need to alter the build config and provide the imagestream/name to build from.


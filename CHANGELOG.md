# Changelog

## [Unreleased]

### Added
- Rundeck `prepare-continous integration` job can now be used to upgrade an existing git repository ([#110](https://github.com/opendevstack/ods-project-quickstarters/pull/110))
- New quickstarter `be-docker-plain`: useful for starting with a plain `Dockerfile` and no BE/FE framework on top ([#97](https://github.com/opendevstack/ods-project-quickstarters/issues/97))
- Maven/Gradle Jenkins slave `jenkins-slave-maven` now gets Nexus credentials injected as server into `settings.xml` ([#127](https://github.com/opendevstack/ods-project-quickstarters/issues/127))
- New quickstarter `ds_ml_service` for machine learning from model training & testing to production ([#111](https://github.com/opendevstack/ods-project-quickstarters/issues/111))
- Quickstarter `fe-angular` now provides coverage analysis data to SonarQube and added SonarQube's linter rules for tslint
- Documentation of all quickstarters and slaves added

### Changed
- Jupyter & R-Shiny quickstarters are now based on new Openresty-based WAF image ([#103](https://github.com/opendevstack/ods-project-quickstarters/pull/103))

### Fixed
- Rshiny quickstarter broken - due to refactoring and webhook proxy introduction ([#200](https://github.com/opendevstack/ods-project-quickstarters/issues/200)) & ([#184](https://github.com/opendevstack/ods-project-quickstarters/issues/184))
- Create-projects.sh seeds wrong jenkins SA rights & misses default SA for webhook proxy bug ([#189](https://github.com/opendevstack/ods-project-quickstarters/issus/189))

## [1.0.2] - 2019-04-02

### Fixed
- Angular quickstarter `fe-angular-frontend` compilation failed due to changed dependency ([#129](https://github.com/opendevstack/ods-project-quickstarters/issues/129))
- Spring boot quickstarter `be-springboot` gradle build failed due to dependency update to gradle 4.10 ([#131](https://github.com/opendevstack/ods-project-quickstarters/issues/131))
- Upgrade of repo, thru rundeck job `prepare-continous integration` fails with invalid device ([#124](https://github.com/opendevstack/ods-project-quickstarters/issues/124))
- Jenkins `python slave` requires pip to have proper ssl validation configuration ([#176](https://github.com/opendevstack/ods-project-quickstarters/issues/176))

## [1.0.1] - 2019-01-25

### Fixed
- Exclude images in `openshift` and `rhscl` namespace on import ([#102](https://github.com/opendevstack/ods-project-quickstarters/pull/102))
- Maven slave fails when proxy is configured due to invalid XML ([#108](https://github.com/opendevstack/ods-project-quickstarters/pull/108))


## [1.0.0] - 2018-12-03

### Added
- Spring Boot Jenkins pipeline surfaces test results (#34)
- Jenkins webhook proxy templates (#81, #82)

### Changed
- Quickstarter build containers (located in the subdirs of https://github.com/opendevstack/ods-project-quickstarters/tree/master/boilerplates) inherit from corresponding Jenkins build slaves now rather than replicating the setup
- Rundeck's OC container inherits from `jenkins-slave-base` now. The pull and tag is triggered thru *verify-rundeck-settings* rundeck job (#32)
- The build of a quickstarter component does not upload the tarball to Nexus anymore - instead it uses binary build configs (#9)
- The containers used to connect to openshift now pull the root ca during build, to ensure SSL trust (#12, #54)
- Slaves now support HTTP/S proxy - inject as ENV - with HTTP_PROXY, HTTPS_PROXY & NO_PROXY (#50)
- Python slave upgraded to 3.6 latest (#24)
- Maven slave now downloads Gradle 4.8.1 during build to increase build performance of components (#23)
- Scala slave now downloads sbt 1.1.6 / scala 2.12 - given an SBT bug - when proxy set, no NEXUS usage
- Update to newest cypress and TypeScript versions (#91)
- Build Jupyter/Rshiny via Jenkins (#92)

### Fixed
- Nodejs 8 quickstarter failed on npm run coverage (#22)
- Rundeck containers not cleaned up (#16, #17)
- Disable inclusion of Nginx server version in HTTP headers (#79)
- Jupyter: install from Nexus (#65)

### Removed
- Remove broken be-database quickstarter (#87)


## [0.1.0] - 2018-07-27

Initial release.

# Python & Flask Server (be-python-flask)

## Purpose of this quickstarter
Use this quickstarter when you want to build a [python](http://flask.pocoo.org/docs/1.0/tutorial/) based server application, e.g. for a trained data science model or for hard data crunching

It contains the basic setup for [Docker](https://www.docker.com/), [Jenkins](https://jenkins.io/), [SonarQube](https://www.sonarqube.org/) and [OpenShift](https://www.openshift.com/).

## What files / architecture is generated?
```
.
├── Jenkinsfile  -  This file contains Jenkins build configuration settings
├── README.md  -  Readme file template
├── docker-compose.yml  -  For running all services locally
├── jenkinsfile_helper.py  -  Helper function used during the Jenkins pipeline
├── build.sh  -  Build Script. This script copies all necessary files to the docker images 
├── docker-prediction  -  This folder contains Docker configuration settings for prediction service
│   └── Dockerfile
├── docker-training  -  This folder contains Docker configuration settings for training service
│   └── Dockerfile
└── src
    ├── static  -  Static resources
    ├── templates  -  Templates used by flask
    ├── requeriments.txt  -  All the dependencies needed
    ├── test_requeriments.txt  -  All the dependencies needed for tests
    ├── tests.py  -  Unit tests
    ├── setup.py  -  All the dependencies needed 
    └── app.py  -  Flask Application code
```
## Frameworks used
1.  [Python (^3)](https://docs.python.org/3/tutorial/)

## Usage - how do you start after you provisioned this quickstarter

1. In case of added/changed requirements.txt do `install --user -r requirements.txt` in the `src` dir.
1. In `src` run your app thru `python3 app.py`

## How this quickstarter is built thru jenkins

The build pipeline is defined in the `Jenkinsfile` in the project root. The mains stages of the pipeline are, 
1.  Build :  `python` command will be executed to test your applicaton and then the `src` dir will be copied to the `docker/dist` folder. 

``` python
def stageBuild(def context) {
  stage('Build') {
    withEnv(["TAGVERSION=${context.tagversion}"]) {
      sh "python src/tests.py"
      // PEP8
      sh '''
         pycodestyle --show-source --show-pep8 src/*
         pycodestyle --statistics -qq src/*
      '''
    }
    sh "cp -r src docker/dist"
  }
}
```

## Builder Slave used 
This quickstarter uses the
[Python3 slave](https://github.com/opendevstack/ods-project-quickstarters/tree/master/jenkins-slaves/python)
builder slave

## Known limitations
n/a
# Python & Flask Server (be-python-flask)

## Purpose of this quickstarter
Use this quickstarter when you want to build a [python](http://flask.pocoo.org/docs/1.0/tutorial/) based server application, e.g. for a trained data science model or for hard data crunching

It contains the basic setup for [Docker](https://www.docker.com/), [Jenkins](https://jenkins.io/), [SonarQube](https://www.sonarqube.org/) and [OpenShift](https://www.openshift.com/).

## What files / architecture is generated?

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
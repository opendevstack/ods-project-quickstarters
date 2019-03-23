# Python & Flask Server (be-python-flask)

## Purpose of this quickstarter
Use this quickstarter when you want to build a [python](http://flask.pocoo.org/docs/1.0/tutorial/) based server application

## What files / architecture is generated?

## Frameworks used

## Usage - how do you start after you provisioned this quickstarter

## How this quickstarter is built thru jenkins

The python slave uos used to test, run pcodestyle and the copy the files to the docker context dir `docker/dist`

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
[Python3 slave](https://github.com/opendevstack/ods-project-quickstarters/tree/master/jenkins-slaves/python)

## Known limitations

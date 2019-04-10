# Airflow Jenkins Slave

## Introduction / Used for building / testing `airflow`
This slave is used to build / execute / test [Airflow](https://airflow.apache.org/) code

The image is built in the global `cd` project and is named `jenkins-slave-airflow`.
It can be referenced in a `Jenkinsfile` with `cd/jenkins-slave-airflow`

## Features / what's in, which plugins, ...
1. Python 3.6
1. PIP

## Known limitations
Not (yet) Nexus package manager aware and no special HTTP Proxy configuration

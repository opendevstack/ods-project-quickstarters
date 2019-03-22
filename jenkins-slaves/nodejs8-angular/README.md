# Node.js 8 - Angular Jenkins Slave

## Introduction / Used for building `node.js` 
This slave is used to build node.js based projects, both thru `npm` and `yarn`

The image is built in the global `cd` project and is named `jenkins-slave-nodejs8-angular`.
It can be referenced in a `Jenkinsfile` with `cd/jenkins-slave-nodejs8-angular` 

## Features / what's in, which plugins, ...
1. Nexus configuration 
2. HTTP Proxy awareness
3. Angular & cypress dependencies pre-installed

## Known limitations
n/a

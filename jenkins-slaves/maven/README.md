# Maven / Gradle Jenkins Slave

## Introduction / Used for building `java`
This slave is used to build java code, both thru `maven` and `gradle`

The image is built in the global `cd` project and is named `jenkins-slave-maven`.
it can be referenced in a `JenkinsFile` with `cd/jenkins-slave-maven` 

## Features / what's in, which plugins, ...
1. Nexus configuration for Maven
1. HTTP Proxy awareness

## Known limitations
n/a

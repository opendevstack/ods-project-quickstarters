# Scala / SBT Jenkins Slave

## Introduction / Used for building `scala` 
This slave is used to build scala code

## Features / what's in, which plugins, ...
1. SBT 1.1.6
1. HTTP Proxy aware
1. Nexus aware

## Known limitations
In case HTTP Proxy config is injected thru environment variables (including NO_PROXY), Nexus configuration is disabled because of an SBT bug

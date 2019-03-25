# Jupyter Notebook 
## Purpose of this quickstarter
Provision a shared jupyter notebook within openshift for rapid prototyping of data science applications using crowd authentification

## What files / architecture is generated?
```
+-- Jenkinsfile  
+-- docker    
| +-- Dockerfile  
| +-- jupyter_notebook_config.json  
| +-- requirements.txt  
| +-- run.sh  
+-- src  
+-- init.sh  
```

## Frameworks used
python 3.6 + jupyter (lab)

## Usage - how do you start after you provisioned this quickstarter
The quickstarter sets up two pods in openshift. The jupyter notebook is routed through a crowd authentication proxy.
For accessing the jupyter notebook use the route exposed by the authentication service:
`<your-component-name>-authrpoxy`


The directory `/app/src/work/storage` is created where code can be organized using installed git.  
Please consider mounting a persistent volume claim for this path.  
New python requirements are specified using the `requirements.txt`


## How this quickstarter is built through jenkins
The build pipeline is defined in the `Jenkinsfile` in the project root. The main stages of the pipeline are:
1. Patch the build configs and inject nexus credentials for installing python dependencies over nexus pypi repository
2. Start openshift build
3. Deploy image to openshift

## Builder slave used
[jenkins-slave-base](https://github.com/opendevstack/ods-core/tree/master/jenkins/slave-base)

## Known limitions
Consider if sufficient computing resources can be provided by the openshift cluster.

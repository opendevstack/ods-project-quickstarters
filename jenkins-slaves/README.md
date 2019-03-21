# Jenkins Slaves

Hosts all the jenkins slaves that are part of the OpenDevStack distribution.

All these slaves inherit from the [slave-base](https://github.com/opendevstack/ods-core/tree/master/jenkins/slave-base), and are built in the global 'CD' project. 

Inside your `jenkinsfile` you can configure which slave is used by changing
```
odsPipeline(
  image: "${dockerRegistry}/cd/jenkins-slave-maven"
```
the ODS [jenkins shared library](https://github.com/opendevstack/ods-jenkins-shared-library) takes care about the rest then.

If you create a new slave please create readme.md inside its directory, based on [template](../__JENKINS_SLAVE_TEMPLATE_README.md)

## OCP config / installation

Config can be created / updated / deleted with Tailor.

Example:
```
cd <slave name>/ocp-config && tailor status
```

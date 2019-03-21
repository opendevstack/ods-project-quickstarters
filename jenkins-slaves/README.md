# Jenkins Slaves

Hosts all the jenkins slaves that are part of the OpenDevStack distribution.

All these slaves inherit from the [slave-base](https://github.com/opendevstack/ods-core/tree/master/jenkins/slave-base), and are built in the global `CD` project. 

Inside your `jenkinsfile` you can configure which slave is used by changing the `image` property to your imagestream (e.g. in case it's in a `project`-cd namespace and not in the global `CD` one).
```
odsPipeline(
  image: "${dockerRegistry}/cd/jenkins-slave-maven"
```
the ODS [jenkins shared library](https://github.com/opendevstack/ods-jenkins-shared-library) takes care about, starting it during the build as pod in your `project`s `cd` namespace with the jenkins service account.

If you create a new slave please create readme.md inside its directory, based on [template](../__JENKINS_SLAVE_TEMPLATE_README.md)

## OCP config / installation

Config can be created / updated / deleted with Tailor.

Example:
```
cd <slave name>/ocp-config && tailor status
```

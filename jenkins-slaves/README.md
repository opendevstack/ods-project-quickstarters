# Jenkins Slaves

Hosts all the jenkins slaves that are part of the OpenDevStack distribution.

All these slaves inherit from the [slave-base](https://github.com/opendevstack/ods-core/tree/master/jenkins/slave-base).

If you create a new slave please create readme.md inside its directory, based on [template](../__JENKINS_SLAVE_TEMPLATE_README.md)

## OCP config / installation

Config can be created / updated / deleted with Tailor.

Example:
```
cd <slave name>/ocp-config && tailor status
```

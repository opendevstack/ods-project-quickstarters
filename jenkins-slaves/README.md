# Jenkins Slaves

Jenkins slaves that are not part of the OpenShift distribution.

All slaves should inherit from the [slave-base](https://github.com/opendevstack/ods-core/tree/master/jenkins/slave-base).

## OCP config

Config can be created / updated / deleted with Tailor.

Example:
```
cd maven/ocp-config && tailor status
```




FROM cd/jenkins-slave-base

MAINTAINER "Andreas Bellmann" <andreas.bellmann@opitz-consulting.com>

RUN oc version

WORKDIR /data/ods-project-quickstarters/ocp-templates/scripts
COPY ods-project-quickstarters/ocp-templates/scripts    /data/ods-project-quickstarters/ocp-templates/scripts
COPY ods-project-quickstarters/ocp-templates/ocp-config /data/ods-project-quickstarters/ocp-templates/ocp-config
COPY ods-configuration                                  /data/ods-configuration

ENTRYPOINT [""]

FROM cd/jenkins-slave-nodejs8-angular

MAINTAINER "Andreas Bellmann" <andreas.bellmann@opitz-consulting.com>

ARG ANGULAR_CLI_VERSION=6.0.7

RUN npm install -g @angular/cli@$ANGULAR_CLI_VERSION && \
    ng version

WORKDIR /data

ENTRYPOINT ["ng"]


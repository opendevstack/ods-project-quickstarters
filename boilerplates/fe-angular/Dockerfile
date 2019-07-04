FROM cd/jenkins-slave-nodejs10-angular

LABEL maintainer="Balram Chavan <balram_morsing.chavan@boehringer-ingelheim.com>"

ARG ANGULAR_CLI_VERSION=8.0.3

RUN npm install -g @angular/cli@$ANGULAR_CLI_VERSION && \
    ng version

WORKDIR /data

ENTRYPOINT ["ng"]


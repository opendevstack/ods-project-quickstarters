FROM cd/jenkins-slave-nodejs8-angular

LABEL maintainer="Akhil Soman <akhil.soman@boehringer-ingelheim.com>"

ARG VUE_CLI_VERSION=3.4.0

RUN npm install -g @vue/cli@$VUE_CLI_VERSION && \
    vue --version

WORKDIR /data

ENTRYPOINT ["vue"]


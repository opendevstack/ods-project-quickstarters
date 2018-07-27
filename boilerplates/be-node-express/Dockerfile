FROM cd/jenkins-slave-nodejs8-angular

MAINTAINER "Andreas Bellmann" <andreas.bellmann@opitz-consulting.com>

ARG YO_VERSION=3.0.0
ARG GENERATOR_VERSION=0.5.1

ENV HOME /home/jenkins

RUN npm install -g yo@$YO_VERSION && \
    npm install -g generator-node-express-typescript@$GENERATOR_VERSION

WORKDIR /data

ENTRYPOINT ["yo"]

CMD ["--help"]
RUN yo --generators



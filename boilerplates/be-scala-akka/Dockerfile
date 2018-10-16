FROM cd/jenkins-slave-scala

MAINTAINER "Clemens Utschig" <clemens.utschig-utschig@boehringer-ingelheim.com>

WORKDIR /data

ENV HOME=/home/jenkins
ENV SBT_CREDENTIALS="/home/jenkins/.sbt/credentials"
ENV SBT_OPTS="-Duser.home=/home/jenkins"

RUN . /tmp/set_java_proxy.sh

RUN mkdir /tmp/akka-http-quickstart-scala.g8
COPY akka-http-quickstart-scala.g8/ /tmp/akka-http-quickstart-scala.g8

ENTRYPOINT [""]

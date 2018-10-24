FROM cd/jenkins-slave-maven

MAINTAINER "Clemens Utschig" <clemens.utschig-utschig@boehringer-ingelheim.com>

ENV HOME=/home/jenkins
ENV SDKMAN_DIR $HOME/.sdkman

RUN \
    curl -s "https://get.sdkman.io" | bash

ARG SPRING_CLI_VERSION

RUN /bin/bash -lc "source /home/jenkins/.sdkman/bin/sdkman-init.sh && sdk install springboot $SPRING_CLI_VERSION && \
    spring --version"

WORKDIR /data

RUN bash -l -c 'echo export JAVA_OPTS="$(./set_java_proxy.sh && echo $JAVA_OPTS)" >> /etc/bash.bashrc'

ENTRYPOINT ["/home/jenkins/.sdkman/candidates/springboot/current/bin/spring"]

CMD ["--help"]

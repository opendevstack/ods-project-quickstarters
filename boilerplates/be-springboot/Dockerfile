FROM cd/jenkins-slave-maven

MAINTAINER "Clemens Utschig" <clemens.utschig-utschig@boehringer-ingelheim.com>

ENV HOME=/home/jenkins
# ENV SDKMAN_DIR $HOME/.sdkman

# RUN \
#    curl -s "https://get.sdkman.io" | bash

ARG SPRING_CLI_VERSION

#RUN /bin/bash -lc "source /home/jenkins/.sdkman/bin/sdkman-init.sh && sdk install springboot $SPRING_CLI_VERSION && \
#    spring --version"
RUN echo $SPRING_CLI_VERSION && \
	mkdir $HOME/spring && \
	cd $HOME/spring

RUN curl -O -L http://repo.spring.io/release/org/springframework/boot/spring-boot-cli/$SPRING_CLI_VERSION/spring-boot-cli-$SPRING_CLI_VERSION-bin.tar.gz 

RUN tar -xvf *.gz

ENV SPRING_HOME /tmp/spring/$SPRING_CLI_VERSION

ENV PATH $SPRING_HOME/bin:$PATH

WORKDIR /data

# set proxy if available 
RUN . /tmp/set_java_proxy.sh && echo $JAVA_OPTS

# ENTRYPOINT ["/home/jenkins/.sdkman/candidates/springboot/current/bin/spring"]
ENTRYPOINT ["spring"]

CMD ["--help"]
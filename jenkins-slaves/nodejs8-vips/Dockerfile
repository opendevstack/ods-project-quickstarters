FROM openshift/jenkins-slave-base-centos7

MAINTAINER Andras Gyacsok <andras.gyacsok@boehringer-ingelheim.com>

ENV NODEJS_VERSION=8 \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable" \
    SONAR_SCANNER_VERSION=3.1.0.1141

COPY contrib/bin/scl_enable /usr/local/bin/scl_enable

# Install NodeJS
RUN yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="rh-nodejs${NODEJS_VERSION} rh-nodejs${NODEJS_VERSION}-npm rh-nodejs${NODEJS_VERSION}-nodejs-nodemon make gcc-c++" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

COPY npmrc $HOME/.npm-global/etc/npmrc
	
RUN sed -i .bak -e "s|NEXUS_HOST|$NEXUS_HOST|g" $HOME/.npm-global/etc/npmrc && \
    sed -i .bak -e "s|NEXUS_AUTH|$(echo -n $NEXUS_AUTH | base64)|g" $HOME/.npm-global/etc/npmrc && \
    rm $HOME/.npm-global/etc/npmrc.bak
	
# Install packages to edit images
ENV LIBVIPS_VERSION_MAJOR=8
ENV LIBVIPS_VERSION_MINOR=6
ENV LIBVIPS_VERSION_PATCH=3
ENV LIBVIPS_VERSION=$LIBVIPS_VERSION_MAJOR.$LIBVIPS_VERSION_MINOR.$LIBVIPS_VERSION_PATCH

RUN INSTALL_PKGS="libpng-devel libwebp-devel libxml2-devel poppler-glib swig glib2-devel libglade2 expat-devel pygobject2 libjpeg-turbo-devel giflib-devel" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

COPY contrib/usrlocal.conf /etc/ld.so.conf.d/

RUN cd /tmp && \
     wget https://github.com/jcupitt/libvips/releases/download/v$LIBVIPS_VERSION/vips-$LIBVIPS_VERSION.tar.gz && \
     tar zvxf vips-$LIBVIPS_VERSION.tar.gz && \
     cd /tmp/vips-$LIBVIPS_VERSION && \
     ./configure --enable-debug=no --without-python $1 && \
     make && \
     make install && \
     ldconfig

# Install Sonar Scanner
RUN cd /tmp && \
    curl -O http://repo1.maven.org/maven2/org/sonarsource/scanner/cli/sonar-scanner-cli/${SONAR_SCANNER_VERSION}/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip && \
    unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip && \
    mv sonar-scanner-${SONAR_SCANNER_VERSION} /usr/local/sonar-scanner-cli && \
    rm -rf sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip sonar-scanner-${SONAR_SCANNER_VERSION}
ENV PATH=/usr/local/sonar-scanner-cli/bin:$PATH

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME
USER 1001

# This image provides a Python 2.7 environment you can use to run your Python
# applications.
FROM openshift/base-centos7

MAINTAINER "Andras Gyacsok" <andras.gyacsok@boehringer-ingelheim.com>

EXPOSE 8080

ENV PYTHON_VERSION=2.7 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off

RUN yum -y update

RUN yum install -y centos-release-scl && \
    INSTALL_PKGS="libjpeg-turbo libjpeg-turbo-devel python27 python27-python-devel python27-python-setuptools \
	python27-python-pip nss_wrapper httpd24 httpd24-httpd-devel httpd24-mod_ssl httpd24-mod_auth_kerb \
        httpd24-mod_ldap httpd24-mod_session atlas-devel gcc-gfortran libffi-devel libtool-ltdl" && \
    yum install -y --setopt=tsflags=nodocs --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    # Remove centos-logos (httpd dependency, ~20MB of graphics) to keep image
    # size smaller.
    rpm -e --nodeps centos-logos && \
    yum clean all -y

# Create a Python virtual environment for use by any application to avoid
# potential conflicts with Python packages preinstalled in the main Python
# installation.
RUN source scl_source enable python27 && \
   virtualenv /opt/app-root

RUN unset BASH_ENV PROMPT_COMMAND ENV && \
    source scl_source enable python27 && \
    source /opt/app-root/bin/activate

COPY dist /opt/app-root/src/
COPY run.sh /opt/app-root/src/

RUN chown -R 1001:0 /opt/app-root && \
    chmod -R ug+rwx /opt/app-root

USER 1001

WORKDIR /opt/app-root/src/

CMD ["./run.sh"]

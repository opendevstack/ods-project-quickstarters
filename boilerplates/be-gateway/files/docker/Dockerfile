FROM kong:1.4-centos

LABEL description="Centos 7 + Kong 1.4 + kong-oidc plugin"

ENV KONG_DATABASE=off
ENV KONG_DECLARATIVE_CONFIG=kong.yml

COPY kong.yml /

RUN cp /etc/kong/kong.conf.default /etc/kong/kong.conf

RUN yum install -y git unzip && yum clean all

RUN luarocks install kong-oidc

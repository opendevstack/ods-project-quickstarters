FROM nginx:1.15.0-alpine

ARG nexusHost
ARG nexusUsername
ARG nexusPassword
ARG projectId
ARG componentId
ARG tagversion

RUN chmod -R 777 /var/log/nginx /var/cache/nginx /var/run \
     && chgrp -R 0 /etc/nginx \
     && chmod -R g+rwX /etc/nginx

RUN apk add --no-cache --virtual .build-deps curl && \
    curl --fail -o docroot.tar.gz -v -u ${nexusUsername}:${nexusPassword} ${nexusHost}/repository/candidates/org/opendevstack/projectId/${componentId}/${tagversion}/${componentId}-${tagversion}.tar.gz && \
    mkdir docroot && \
    tar xzvf docroot.tar.gz -C docroot && \
    mv docroot/${componentId} docroot_tmp && \
    rm -rf docroot && \
    mv docroot_tmp docroot && \
    rm docroot.tar.gz && \
    chown -R nginx: /docroot && \
    rm -rf /var/cache/apk/*

EXPOSE 8080

COPY nginx.vh.default.conf.nginx /etc/nginx/conf.d/default.conf

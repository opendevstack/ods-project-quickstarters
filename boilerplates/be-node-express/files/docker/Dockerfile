FROM node:6-alpine

RUN apk add --no-cache --virtual .build-deps curl && \
    mkdir /node && \
    rm -rf /var/cache/apk/*

ARG nexusHost
ARG nexusUsername
ARG nexusPassword
ARG projectId
ARG componentId
ARG tagversion

RUN curl --fail -s -o dist.tar.gz -u ${nexusUsername}:${nexusPassword} ${nexusHost}/repository/candidates/org/opendevstack/projectId/${componentId}/${tagversion}/${componentId}-${tagversion}.tar.gz && \
    tar xzf dist.tar.gz -C /node && \
    chown -R node: /node

EXPOSE 8080

USER node
WORKDIR node
CMD ["node", "lib/index.js"]



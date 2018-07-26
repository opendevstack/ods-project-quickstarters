FROM openjdk:8-jre-alpine

ARG nexusHost
ARG nexusUsername
ARG nexusPassword
ARG projectId
ARG componentId
ARG tagversion

RUN apk add --no-cache --virtual .build-deps curl htop && \
    curl --fail -o app.jar -v -u ${nexusUsername}:${nexusPassword} ${nexusHost}/repository/candidates/org/opendevstack/projectId/${componentId}/${tagversion}/${componentId}-${tagversion}.jar

EXPOSE 8080

CMD ["java","-Xmx512m", "-jar", "app.jar"]

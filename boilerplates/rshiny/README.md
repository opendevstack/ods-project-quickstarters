# BI-X RShiny MVP

## Create project
```
oc new-project bix-rshiny-mvp
```

## Setup secrets for CD and Hive
```
oc secrets new-basicauth cd-user --username=cd_user --prompt=true
oc secrets new-basicauth hive-user --username=x2ardigen --prompt=true
```

## Build Configurations for app and authproxy
```
oc process -f rshiny-templates/bc-docker.yml \
    PROJECT=bix-rshiny-mvp \
    COMPONENT=app \
    GIT_URL=https://bitbucket.bix-digital.com/scm/bixmvp/bix-rshiny-mvp.git | oc create -f -
oc start-build app -n bix-rshiny-mvp

oc process -f rshiny-templates/bc-docker.yml \
    PROJECT=bix-rshiny-mvp \
    COMPONENT=authproxy \
    GIT_URL=https://bitbucket.bix-digital.com/scm/bixmvp/bix-rshiny-mvp-authproxy.git | oc create -f -
oc start-build authproxy -n bix-rshiny-mvp
```

## Deployment
```
htpasswd -cb htpasswd bix bix
oc process -f rshiny-templates/dc-rshiny-app-with-authproxy.yml \
    PROJECT=bix-rshiny-mvp \
    COMPONENT=app \
    APPLICATION=app1 \
    HTPASSWD="$(cat htpasswd)" | oc create -f -
oc deploy authproxy
oc deploy app
```

## TLS Route
```
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
oc create route edge app1 \
    --service=authproxy \
    --cert=cert.pem \
    --key=key.pem \
    --ca-cert=cert.pem \
    --hostname=bix-rshiny-mvp.22ad.bi-x.openshiftapps.com
```

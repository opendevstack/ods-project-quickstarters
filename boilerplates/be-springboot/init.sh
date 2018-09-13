#!/usr/bin/env bash
set -eux

# Get directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while [[ "$#" > 0 ]]; do case $1 in
  -p=*|--project=*) PROJECT="${1#*=}";;
  -p|--project) PROJECT="$2"; shift;;

  -c=*|--component=*) COMPONENT="${1#*=}";;
  -c|--component) COMPONENT="$2"; shift;;

  -k=*|--package=*) PACKAGE="${1#*=}";;
  -k|--package) PACKAGE="$2"; shift;;

  -g=*|--group=*) GROUP="${1#*=}";;
  -g|--group) GROUP="$2"; shift;;

  -t=*|--target-dir=*) TARGET_DIR="${1#*=}";;
  -t|--target-dir) TARGET_DIR="$2"; shift;;

  -o=*|--owner=*) OWNER="${1#*=}";;
  -o|--owner) OWNER="$2"; shift;;

  *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done

cd $TARGET_DIR
sudo chgrp -R 0 .

echo "read args: project=$PROJECT, component=$COMPONENT, package=$PACKAGE, group=$GROUP"

echo "init springboot project"
sudo docker run --rm -v $PWD:/data springboot init \
  --build=gradle \
  --java-version="1.8" \
  --groupId=$PROJECT \
  --artifactId=$COMPONENT \
  --package-name="$PACKAGE" \
  --packaging=jar \
  --dependencies="web,jersey,data-jpa,h2,lombok,data-rest,restdocs,security" \
  $COMPONENT

cd $COMPONENT

sudo chown -R $OWNER .

echo "configure in memory database in spring application.properties"
echo "spring.profiles.active: dev" > src/main/resources/application.properties
echo "spring.jpa.database: HSQL" > src/main/resources/application-dev.properties

echo "customise build.gradle"

sed -i.bak '/springBootVersion =/a \
    nexus_url = "\${project.findProperty("nexus_url") ?: System.getenv("NEXUS_HOST")}"\
    nexus_folder = "candidates"\
    nexus_user = "\${project.findProperty("nexus_user") ?: System.getenv("NEXUS_USERNAME")}"\
    nexus_pw = "\${project.findProperty("nexus_pw") ?: System.getenv("NEXUS_PASSWORD")}"\
' build.gradle

sed -i.bak 's/mavenCentral()/maven () {\
        url "${nexus_url}\/repository\/jcenter\/"\
        credentials {\
          username = "${nexus_user}"\
          password = "${nexus_pw}"\
        }\
      }\
\
      maven () {\
        url "${nexus_url}\/repository\/maven-public\/"\
        credentials {\
          username = "${nexus_user}"\
          password = "${nexus_pw}"\
        }\
      }\
\
      maven () {\
        url "${nexus_url}\/repository\/atlassian_public\/"\
        credentials {\
          username = "${nexus_user}"\
          password = "${nexus_pw}"\
        }\
      }\
/g' build.gradle

sed -i.bak "s/\(apply plugin: 'java'\)/\1\napply plugin: 'maven'\napply plugin: 'jacoco'/g" build.gradle

# by default no jar task in there .. we need to add it.
echo -e "jar {\n    archiveName     "app.jar"\n    destinationDir  file("$buildDir/../docker")\n}" >> test.gradle

rm build.gradle.bak

cat >> build.gradle <<EOL
uploadArchives {
    repositories{
        mavenDeployer {
            repository(url: "\${nexus_url}/repository/\${nexus_folder}/") {
                 authentication(userName: "\${nexus_user}", password: "\${nexus_pw}")
            }
            pom.artifactId = '$COMPONENT'
            pom.groupId = '$GROUP'
            pom.version="\${System.getenv("TAGVERSION")}" // we will get a TAGVERSION from environment
        }
    }
}
EOL

echo "fix nexus repo path"
repo_path=$(echo "$GROUP" | tr . /)
sed -i.bak "s|org/opendevstack/projectId|$repo_path|g" $SCRIPT_DIR/files/docker/Dockerfile
rm $SCRIPT_DIR/files/docker/Dockerfile.bak

echo "copy custom files from quickstart to generated project"
cp -rv $SCRIPT_DIR/files/. .

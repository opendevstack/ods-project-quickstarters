#!/usr/bin/env bash
set -eux

# Get directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

while [[ "$#" > 0 ]]; do case $1 in
  -p=*|--project=*) PROJECT="${1#*=}";;
  -p|--project) PROJECT="$2"; shift;;

  -c=*|--component=*) COMPONENT="${1#*=}";;
  -c|--component) COMPONENT="$2"; shift;;

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

echo "generate project from local template"
sudo docker run --rm -v $PWD:/data scala \
   sbt -Dsbt.version=$SBT_VERSION -v file:///tmp/akka-http-quickstart-scala.g8 --name=$COMPONENT
 
cd $COMPONENT 

sudo chown -R $OWNER .

echo "fix nexus repo path"
repo_path=$(echo "$GROUP" | tr . /)
sed -i.bak "s|org/opendevstack/projectId|$repo_path|g" $SCRIPT_DIR/files/docker/Dockerfile
rm $SCRIPT_DIR/files/docker/Dockerfile.bak

echo "copy custom files from quickstart to generated project"
cp -rv $SCRIPT_DIR/files/. .

# overwrite sbt version - bug in > 1.0 - so leave 0.13.17

# add assembly otherwise sbt assembly fails
echo "addSbtPlugin(\"com.eed3si9n\" % \"sbt-assembly\" % \"0.14.5\")" >> project/plugins.sbt
echo "addSbtPlugin(\"com.typesafe.sbt\" % \"sbt-native-packager\" % \"1.3.2\")" >> project/plugins.sbt

# add output path for assembly
echo "enablePlugins(JavaAppPackaging)" >> build.sbt
echo "assemblyOutputPath in assembly := file(\"/tmp/sclapp.jar\")" >> build.sbt

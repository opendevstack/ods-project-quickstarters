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
echo "generate project"
sudo docker run --rm -v $PWD:/data \
  ng new $COMPONENT --style=scss --skip-git --skip-install && npm --prefix $COMPONENT i jest-junit

cd $COMPONENT

sudo chown -R $OWNER .

echo "Configure headless chrome in karma.conf.j2"
read -r -d "" CHROME_CONFIG << EOM || true
    browsers: \['ChromeNoSandboxHeadless'\],\\
\\
    customLaunchers: {\\
      ChromeNoSandboxHeadless: {\\
        base: 'Chrome',\\
        flags: \[\\
          '--no-sandbox',\\
          // See https://chromium.googlesource.com/chromium/src/+/lkgr/headless/README.md\\
          '--headless',\\
          '--disable-gpu',\\
          // Without a remote debugging port, Google Chrome exits immediately.\\
          ' --remote-debugging-port=9222',\\
        \],\\
      },\\
    },
EOM
sed -i "s|\s*browsers: \['Chrome'\],|$CHROME_CONFIG|" ./src/karma.conf.js
sed -i "s|\(browsers:\)|    \1|g" ./src/karma.conf.js

echo "Configure xml unit test reporter in karma.conf.j2"
read -r -d "" UNIT_TEST_XML_CONFIG << EOM || true
    reporters: \['progress', 'junit', 'kjhtml'\],\\
\\
    junitReporter: {\\
      outputDir: './build/test-results/test',\\
      outputFile: 'test-results.xml',\\
      useBrowserName: false,\\
      xmlVersion: 1\\
    },
EOM
sed -i "s|\s*reporters: \['progress', 'kjhtml'\],|$UNIT_TEST_XML_CONFIG|" ./src/karma.conf.js

echo "Configure headless chrome in protractor.conf.js"
read -r -d '' PROTRACTOR_CONFIG << EOM || true
    'browserName': 'chrome',\\
    'chromeOptions': {\\
      'args': \[\\
        'headless',\\
        'no-sandbox',\\
        'disable-web-security'\\
      \]\\
    },
EOM

sed -i "s|\s*'browserName': 'chrome'|$PROTRACTOR_CONFIG|" ./e2e/protractor.conf.js
sed -i "s|\('browserName'\)|    \1|g" ./e2e/protractor.conf.js

echo "fix nexus repo path"
repo_path=$(echo "$GROUP" | tr . /)
sed -i.bak "s|org/opendevstack/projectId|$repo_path|g" $SCRIPT_DIR/files/docker/Dockerfile
rm $SCRIPT_DIR/files/docker/Dockerfile.bak

echo "copy custom files from quickstart to generated project"
cp -rv $SCRIPT_DIR/files/. .

#!/bin/bash
set -eux

while [[ "$#" > 0 ]]; do case $1 in
  -d=*|--dir=*) directory="${1#*=}";;
  -d|--dir) directory="$2"; shift;;

  -u=*|--url=*) git_url_ssh="${1#*=}";;
  -u|--url) git_url_ssh="$2"; shift;;

  *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done

cd $directory
git init .
git config --global user.email "undefined"
git config --global user.name "CD System User"
git add --all .
git commit -m "Initial commit"
git remote add origin "$git_url_ssh"
git push -u origin master

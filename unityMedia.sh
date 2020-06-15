#!/bin/bash

BASE=$(dirname $0);

if [ -z $1 ]; then
  echo
  echo "Usage: $0 <user account>"
  echo
  exit 1;
fi

cd $BASE

rm selenium-screenshot-*.png
robot -v USER_NAME:$1 unityMedia.robot

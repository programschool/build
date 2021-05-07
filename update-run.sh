#!/usr/bin/env bash

echo "install run command"

mkdir /programschool/execute
cd /programschool/execute
mkdir bin output source
curl -sl https://build.boxlayer.com/run.sh -o run.sh
curl -sl https://build.boxlayer.com/pjson.py -o pjson.py
chmod 555 run.sh pjson.py

exit 0

#!/usr/bin/env bash

pycmd=python2
{
  $pycmd --version > /dev/null 2>&1
} || {
  pycmd=python3
}
$pycmd --version

params=$(echo $1 | base64 -d)

code=$($pycmd pjson.py $params code | base64 -d)
run=$($pycmd pjson.py $params command | base64 -d)
suffix=$($pycmd pjson.py $params fileSuffix | base64 -d)
compiled=$($pycmd pjson.py $params compiled | base64 -d)
output=$($pycmd pjson.py $params output | base64 -d)
targetFileSuffix=$($pycmd pjson.py $params targetFileSuffix | base64 -d)

fileName=$(echo $code | md5sum | cut -d' ' -f1)
echo "$code" > source/$fileName$suffix

if [[ $compiled = true ]]
then
  # 需要编译才能运行
  { # try
    command $run source/$fileName$suffix $output bin/$fileName$targetFileSuffix > output/$fileName 2>&1 &&
    command timeout 10 bin/$fileName$targetFileSuffix > output/$fileName 2>&1
  } || { # catch
    # save log for exception
    command $run source/$fileName$suffix $output bin/$fileName$targetFileSuffix > output/$fileName 2>&1
  }
  res=$(cat output/$fileName | base64)
  echo "::::$res"
else
  # 无需编译即可运行
  command timeout 10 $run source/$fileName$suffix > output/$fileName 2>&1
  res=$(cat output/$fileName | base64)
  echo "::::$res"
fi

#!/usr/bin/env bash
# set -x

PWD=`pwd`
app=`basename $PWD`
version=`grep 'version =' ${app}/default/app.conf | awk '{print $3}' | sed 's/\.//g'`

tar -czf ${app}_${version}.tgz ${app} --exclude=${app}/local --exclude=${app}/metadata/local.meta
echo "Wrote: ${app}_${version}.tgz"

exit 0

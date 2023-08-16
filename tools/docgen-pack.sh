#!/bin/bash
# This script builds and packs the artifacts. Use when you have MSBuild installed.
ksversion=$(cat version)

# Check for dependencies
rarpath=`which rar`
if [ ! $? == 0 ]; then
	echo rar is not found.
	exit 1
fi

# Pack documentation
echo Packing documentation...
"$rarpath" a -ep1 -r -m5 /tmp/$ksversion-doc.rar "../docs/"
if [ ! $? == 0 ]; then
	echo Packing using rar failed.
	exit 1
fi

# Inform success
rm -rf "../DocGen/api"
rm -rf "../DocGen/obj"
rm -rf "../docs"
mv /tmp/$ksversion-doc.rar .
echo Pack successful.
exit 0

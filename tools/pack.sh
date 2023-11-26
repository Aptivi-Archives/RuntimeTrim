#!/bin/bash
# This script builds and packs the artifacts. Use when you have MSBuild installed.
ksversion=$(cat version)

# Check for dependencies
zippath=`which zip`
if [ ! $? == 0 ]; then
	echo zip is not found.
	exit 1
fi

# Pack binary
echo Packing binary...
cd "../RuntimeTrim/bin/Release/net8.0/" && "$zippath" -r /tmp/$ksversion-bin.zip . && cd -
if [ ! $? == 0 ]; then
	echo Packing using zip failed.
	exit 1
fi

# Inform success
mv ~/tmp/$ksversion-bin.zip .
echo Build and pack successful.
exit 0

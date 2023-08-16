#!/bin/bash
# This script builds this project. Use when you have dotnet installed.
ksversion=$(cat version)
ksreleaseconf=$1
if [ -z $ksreleaseconf ]; then
	ksreleaseconf=Release
fi

# Check for dependencies
dotnetpath=`which dotnet`
if [ ! $? == 0 ]; then
	echo dotnet is not found.
	exit 1
fi

# Download packages
echo Downloading packages...
"$dotnetpath" msbuild "../RuntimeTrim.sln" -t:restore -p:Configuration=$ksreleaseconf
if [ ! $? == 0 ]; then
	echo Download failed.
	exit 1
fi

# Build
echo Building...
"$dotnetpath" msbuild "../RuntimeTrim.sln" -p:Configuration=$ksreleaseconf
if [ ! $? == 0 ]; then
	echo Build failed.
	exit 1
fi

# Inform success
echo Build successful.
exit 0

#!/bin/bash
# This script builds and packs the artifacts. Use when you have MSBuild installed.
ksversion=$(cat version)

# Check for dependencies
msbuildpath=`which docfx`
if [ ! $? == 0 ]; then
	echo DocFX is not found.
	exit 1
fi

# Build
echo Building documentation...
docfx DocGen/docfx.json
if [ ! $? == 0 ]; then
	echo Build failed.
	exit 1
fi

# Inform success
echo Build successful.
exit 0

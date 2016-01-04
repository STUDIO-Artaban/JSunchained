#!/bin/bash

# Check mode
if [ "$1" != "MODE=Debug" ] && [ "$1" != "MODE=Release" ]; then
	echo "Wrong expected mode: MODE=Debug|Release"
	exit 1
fi

rm -R Build/Products/${1:5}-iphoneos/MobappJS.framework/Headers

cp -R MobappJS/UIMobapp/ Build/Products/${1:5}-iphoneos/MobappJS.framework/Headers
find Build/Products/${1:5}-iphoneos/MobappJS.framework/Headers -name *.mm -delete

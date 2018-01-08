#!/bin/bash
PATH_SCRIPT=$(dirname $(find $(pwd) ! -readable -prune -o -print | grep build-all.sh))
PATH_PROJECT=${PATH_SCRIPT//\/scripts/}
PATH_PROJECT_ROOT=${PATH_PROJECT//\/golang-server-static/}

echo -e "\t\n$PATH_SCRIPT"

echo -e "\t\n$PATH_PROJECT"

echo -e "\t\n$PATH_PROJECT_ROOT"

echo -e "\t\nBuild binary file for arm processor..."
$PATH_SCRIPT/build-arm.sh

echo -e "\t\nBuild binary file for linux x32..."
$PATH_SCRIPT/build-linux-x32.sh

echo -e "\t\nBuild binary file for linux x64..."
$PATH_SCRIPT/build-linux-x64.sh


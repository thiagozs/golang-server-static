#!/bin/bash

PATH_SCRIPT=$(dirname $(find $(pwd) ! -readable -prune -o -print | grep build-docker-image.sh))

cd $PATH_SCRIPT
cd ..

#get password of dockerhub
USER=$1
SALT=$2
PROJECT=$3
SECRET=$(cat scripts/dockerhub-passwd.txt)
PWD=$(scripts/get-passwd.sh $SECRET $SALT)
sleep 1

echo
echo "Remove Directory dist/* ..."
rm dist -fr

echo
echo "Compile dist ..."
ng build -prod --aot --no-sourcemap

echo
echo "Retrieving last tag from dockerhub ..."
LAST_TAG_DOCKERHUB=$(scripts/dockerhub-list-repo.sh $USER $PWD $USER $PROJECT | grep -v "$PROJECT" | grep - | head -n1 | sed "s/-//g")

if [ -z "${LAST_TAG_DOCKERHUB}" ]; then
    echo "First Tag... 1.0.0"
    LAST_TAG_DOCKERHUB=1.0.0
fi

if [ "${LAST_TAG_DOCKERHUB}" == "1.0.0" ]; then
  INC_TAG=1.0.0
else
  echo
  echo "Increment tag ..."
  INC_TAG=$(scripts/increment_version.sh $LAST_TAG_DOCKERHUB)
fi

echo
echo "New tag = $INC_TAG"

echo
echo "Build image ..."
sudo docker build -t $USER/$PROJECT:${INC_TAG} .

echo
echo "List local images ..."
sudo docker images | grep $PROJECT | grep -v $USER

cd --

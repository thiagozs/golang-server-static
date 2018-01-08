#!/bin/bash

PATH_SCRIPT=$(dirname $(find $(pwd) ! -readable -prune -o -print | grep build-arm.sh))

cd $PATH_SCRIPT
cd ..

FILE="bin/http-server-arm"

if [ -f "$FILE" ]
then
	echo "$FILE found! Remove old version..."
    rm -fr $FILE
else
	echo "$FILE not found. Generate a new one!"
fi

env GOARM=7 GOARCH=arm GOOS=linux go build -v -o bin/http-server-arm src/server/main.go

cd --
#!/bin/bash

PATH_SCRIPT=$(dirname $(find $(pwd) ! -readable -prune -o -print | grep build-linux-x64.sh))

cd $PATH_SCRIPT
cd ..

FILE="bin/http-server-x64"

if [ -f "$FILE" ]
then
	echo "$FILE found! Remove old version..."
    rm -fr $FILE
else
	echo "$FILE not found. Generate a new one!"
fi

env GOARCH=amd64 GOOS=linux go build -v -o bin/http-server-x64 server/main.go

cd --
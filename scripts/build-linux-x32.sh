#!/bin/bash

PATH_SCRIPT=$(dirname $(find $(pwd) ! -readable -prune -o -print | grep build-linux-x32.sh))

cd $PATH_SCRIPT
cd ..

FILE="bin/http-server-x32"

if [ -f "$FILE" ]
then
	echo "$FILE found! Remove old version..."
    rm -fr $FILE
else
	echo "$FILE not found. Generate a new one!"
fi

env GOARCH=386 GOOS=linux go build -v -o bin/http-server-x32 src/server/main.go

cd --
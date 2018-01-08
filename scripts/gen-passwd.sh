#!/bin/bash

CMDGEN="echo '$1' | openssl aes-256-cbc -a -salt"
OUTPUT=$(
    expect << EOD
        log_user 0
        spawn sh -c "$CMDGEN"
        expect "*password:*"
        send "$2\r"
        sleep 1
        expect "*password:*"
        send "$2\r"
        sleep 1
        set result $expect_out(buffer)
        interact
        puts -nonewline "$result"
        expect eof
EOD
)

echo $OUTPUT | sed "s/ //g" | tr -d "\n\r"
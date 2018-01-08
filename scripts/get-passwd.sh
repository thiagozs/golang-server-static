#!/bin/bash

CMDGET="echo '$1' | openssl aes-256-cbc -a -d -salt"
OUTPUT2=$(
    expect << EOD
        log_user 0
        spawn sh -c "$CMDGET"
        expect "*password:*"
        send "$2\r"
        sleep 1
        set result $expect_out(buffer)
        interact
        puts -nonewline "$result"
        expect eof
EOD
)

echo "$OUTPUT2" | sed "s/ //g" | tr -d "\n\r"

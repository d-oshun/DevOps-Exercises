#!/bin/sh

before=""

while read -r now;
do
    if [ "$before" = "$now" ]
    then
        echo "$now"
        exit 0
    fi

    before="$now"
done

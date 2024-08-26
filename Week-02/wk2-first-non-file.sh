#!/bin/sh

while read arg && test -f "$arg"
do
    :
done

echo "$arg"

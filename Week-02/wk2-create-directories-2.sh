#!/bin/sh

for number in $(seq -f %06g $1);
do
    mkdir "dir.$number"
done

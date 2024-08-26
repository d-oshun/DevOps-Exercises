#!/bin/sh

for number in $(seq $1);
do
    mkdir "dir.$number"
done

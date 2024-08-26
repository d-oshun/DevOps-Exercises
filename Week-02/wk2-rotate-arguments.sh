#!/bin/sh

first=$1
shift

for arg in "$@"; do
   echo -n "$arg "
done

echo "$first"

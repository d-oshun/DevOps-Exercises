#!/bin/sh

for arg in "$@";do
    ! test -f "$arg" && exit 1
done
exit 0

#!/bin/sh
args=$*
if [[ $# -eq 0 ]]; then
    args=.
fi
find $args -name ".*.swp" -exec rm {} \;

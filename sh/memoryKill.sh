#!/bin/sh

VALVE=`expr 1024 \* 1024 \* 3` #KB
arg=$1
ps axo "pid,rss,pcpu,comm,cmd" | egrep "$arg" | grep -v 'egrep' | awk '{if($2 > VALVE) print $1;}' VALVE="$VALVE" | xargs kill -9

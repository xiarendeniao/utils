#!/bin/bash
aimdir=$*
if [[ $# -eq 0 ]]; then
    aimdir='/root/xds/xx'
fi

pids=`ps axo "pid,lstart,etime,stat,vsize,rss,euid,ruid,tty,tpgid,sess,pgrp,ppid,pcpu,comm,cmd" | egrep "a|b|c|d" | grep -v 'egrep' | awk '{print $1}'` 
echo $pids
for pid in $pids; do
    cwdir=`ls -lhrt /proc/$pid/cwd | awk '{print $NF}'`
    echo $cwdir
    if [[ $cwdir == $aimdir ]]; then
        echo $cwdir 'killed' $pid
        kill -9 $pid
    fi
    echo $cwdir
done

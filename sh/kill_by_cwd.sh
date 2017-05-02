#!/bin/bash
aimdir=$*
if [[ $# -eq 0 ]]; then
    aimdir='/root/xds/mobstar/mobstar-server/server'
fi

pids=`ps axo "pid,lstart,etime,stat,vsize,rss,euid,ruid,tty,tpgid,sess,pgrp,ppid,pcpu,comm,cmd" | egrep "dbserver|mapserver|loginserver|baseserver|connectserver|crossmapserver|crossproxy|proxyserver|run_game\.sh|run_pk\.sh|run_global\.sh|run_all\.sh" | grep -v 'egrep' | grep -v "scripts" | grep -v "gdb" | awk '{print $1}'` 
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

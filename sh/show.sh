#!/bin/sh
ps axo "pid,lstart,etime,stat,vsize,rss,euid,ruid,tty,tpgid,sess,pgrp,ppid,pcpu,comm,cmd" | egrep "server" | grep -v 'egrep'

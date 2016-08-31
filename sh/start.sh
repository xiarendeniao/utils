#!/bin/sh
waitserver() { 
	while [[ 1 ]] 
	do
		if [[ $1 != 0 ]]
		then 
			echo "."| nc 0.0.0.0 $1
			if [[ $? == 0 ]]
			then 
				break; 
			else 
				echo "server for port "$1" not listened"
				sleep 1
			fi
		fi 
	done
} 

if [[ ! -f server ]]; then
    cd /home/server/
    echo "cd /home/server/"
fi
./server server1.conf > server1.log  2>&1 &
waitserver 6530
./server server2.conf > server2.log 2>&1 &

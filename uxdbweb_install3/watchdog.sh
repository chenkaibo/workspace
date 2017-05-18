#!/bin/bash
INTERVAL=3
while :;do
	sleep "$INTERVAL"
	process=`ps -ef | grep uxweb.jx | grep -v grep`;
	proSize=${#process};
	if [ "$proSize" -le 0 ];then
	      ./start_web
	fi
done;	

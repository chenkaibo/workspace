#!/bin/bash

process=`ps -ef | grep watchdogserver | grep -v 'grep'`;
proSize=${#process};
echo "$proSize";
if [ "$proSize" -le 0 ];then
	nohup ./watchdogserver >/dev/null 2>&1 &
	sleep 1
#	watchdog=`ps -ef | grep watchdogserver | grep -v 'grep'`;
 #       watchdogS=${#watchdog};
#	if [ "$watchdogS" -gt 0 ];then
		echo "uxdbweb watchdag start success!";
#	else
#		echo "uxdbweb watchdog start faild!";
#		exit 1	
#	fi	
else
   echo "uxdbweb watchdog has been start!"
   exit 1
fi

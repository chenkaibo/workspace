#!/bin/bash
UXDB_PATH=/home/uxdb/uxdbinstall/uxdbweb
cd $UXDB_PATH/uxdbweb
#export PATH=$PATH:$UXDB_PATH/node/node-v4.2.3-linux-x64/bin/
nohup ./jx uxweb.jx >$UXDB_PATH/uxdbweb.log 2>&1 &
sleep 1
process=`ps -ef | grep uxweb.jx | grep -v 'grep'`
proSize=${#process}
if [ "$proSize" -gt 0 ];then
	echo "uxdbweb start success!"
else
	echo "uxdbweb start faild!"
fi			 

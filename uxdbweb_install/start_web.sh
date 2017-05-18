#!/bin/bash
UXDB_PATH=/home/uxdb/uxdbinstall/uxdbweb
cd $UXDB_PATH/uxdbweb
export PATH=$PATH:$UXDB_PATH/node-v4.2.3-linux-x64/bin/
nohup node www.js >$UXDB_PATH/uxdbweb.log 2>&1 &
if [ 0 -eq "$?" ];then
   echo "start uxdbweb success"
fi

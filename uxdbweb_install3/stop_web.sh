#!/bin/bash
#check uxdbweb already start?
process=`ps -ef | grep uxweb.jx | grep -v 'grep' | awk '{print $2}'`
if [ -n "$process" ];then
       kill -9 $process
       if [ 0 -eq $? ];then
	       echo "stop uxdbweb success!"
       else
	       echo "stop uxdbweb faild!"
       fi       	       
else
	echo "uxdbweb not start"
fi        

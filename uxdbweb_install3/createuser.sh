#!/bin/bash
DEFAULT_PORT=5532
DEFAULT_UXDB_PATH="/home/uxdb/uxdbinstall"
DEFAULT_USER="uxdbwebuser"
DEFAULT_IP="localhost"
while : ;do
       read -p "Please enter uxdb install path[$DEFAULT_UXDB_PATH]:" uxdbPath

	#checkout uxdbPath

	if [ -z "$uxdbPath" ];then
		uxdbPath="$DEFAULT_UXDB_PATH"
		break
	fi
		 
	if [ ! -d "$uxdbPath" ];then
		echo ""$uxdbPath" is not directory!please enter again:"
	else
		uxdbPath="$uxdbPath"
                break		
	fi
	
done
read -p "Please enter the uxdb IP for webserver [$DEFAULT_IP]:" IP
if [ -z "$IP" ];then
         IP="$DEFAULT_IP"
else
         IP="$IP"    
fi
read -p "Please enter the uxdb port for webserver[$DEFAULT_PORT]:" userPort
if [ -z "$userPort" ];then
	userPort="$DEFAULT_PORT"
else
	userPort="$userPort"	
fi
echo -e "Please enter uxdb \c"
"$uxdbPath"/dbsql/bin/uxsql -h $IP -p "$userPort" --command "create user $DEFAULT_USER with password 'hn5sFyvrgH' superuser"
if [ 0 -eq $? ];then
        echo -e "create user success!\nuser:"$DEFAULT_USER""
fi	 

#!/bin/bash
DEFAULT_PORT=5532
DEFAULT_UXSQL_PATH="/home/uxdb/uxdbinstall"
read -p "Please input uxdbwebdb \c" user
tmp=3
while [ "$tmp" != 0 ];do
    read -p "Please enter uxdb install path["$DEFAULT_UXSQL_PATH"]:" uxdbPath

	#checkout uxdbPath

	if [ -z "$uxdbPath" ];then
		uxdbPath="$DEFAULT_UXSQL_PATH"
		break
	fi
		 
	if [ -d "$uxdbPath" ];then
		echo ""$uxdbPath" is not directory!please input again:"
		let tmp--
	else
		uxdbPath="$uxdbPath"
        break		
	fi
	
	if [ "$tmp" -eq 0 ];then
	    echo "illgeal input more than 3 times and exit"
		exit 1
	fi
done
"$DEFAULT_UXSQL_PATH"/dbsql/bin/uxsql -p $DEFAULT_PORT --command "create "$user" uxdbwebuser with password 'hn5sFyvrgH' superuser" >/dev/null 2>&1
if [ 0 -eq $? ] ; then
	echo "create user success!"
else
	echo "create user faild!"
fi

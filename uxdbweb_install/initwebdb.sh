#!/bin/bash

function initwebdb(){
	echo -e "The full path of uxdb installed[/home/uxdb/uxdbinstall]:\c"
	read uxdb_path
	if [[ -z $uxdb_path ]]; then
		uxdb_path="/home/uxdb/uxdbinstall"
	fi
	initdbresult=1
        checkfileflag=1
        num=3
        while [[ 0 -ne $checkfileflag ]];
        do
            let num--;
            if [[ 0 -eq $num ]]; then
                   echo "Please check your path of uxdb installed is correct!"
                   exit 2
            fi
            if [[ "/" != ${uxdb_path:0:1} ]]; then
                   echo -e "Please enter full path of uxdb installed:\c"
                   read uxdb_path
            else
                   if [[ -e $uxdb_path ]]; then
                           UXDBPATH=${uxdb_path%*/}
                           if [[ ! -e $UXDBPATH/dbsql/bin/initdb ]]; then
                                  echo "There is no \"initdb\" file in directory \"$UXDBPATH\",please retry!"
                                  echo -e "Please enter full path of uxdb installed:\c"
                                  read uxdb_path
                           else
				  export PATH=$PATH:$UXDBPATH/dbsql/bin
				  dbport=5532
				  read -p "Please enter port of uxdbwebdb[5532]:" portTmp
				  if [ ! -z $portTmp ] ; then
					dbport=$portTmp
				  fi
                                  $UXDBPATH/dbsql/bin/initdb -D $UXDBPATH/uxdbwebdb -W
                                  initdbresult=$?
								  
				  if [ 0 -ne $initdbresult ] ; then
					echo "uxdbwebdb initial faild!"
					exit 1
				  fi
				  portStr="port = $dbport"
				  sed -i "s/#port = 5432/$portStr/g" $UXDBPATH/uxdbwebdb/uxsinodb.conf
                                  checkfileflag=0
                           fi
                   else
                           echo "The path $uxdb_path does not exist,please retry!"
                           echo -e "Please enter full path of uxdb installed:\c"
                           read uxdb_path
                   fi
            fi
     done
}

function startwebdb(){
	webdbpath=$UXDBPATH
	echo -e "\nThe full path of uxdbwebdb[$UXDBPATH/uxdbwebdb]:\c"
	read path_str
	if [[ -n $path_str ]]; then 
		if [[ ! -e $path_str ]]; then
			echo "The path \"$path_str\" does not exist,start faild!"
			exit 3
		fi
		webdbpath=$path_str
	fi

	if [[ ! -e $UXDBPATH/dbsql/bin/ux_ctl ]]; then
                echo "There is no \"ux_ctl\" file in directory \"$UXDBPATH\",start faild!"
		exit 3
	fi

	export PATH=$PATH:$UXDBPATH/dbsql/bin
	$UXDBPATH/dbsql/bin/ux_ctl start -D $webdbpath/uxdbwebdb/
}
function uxdbwebdb(){
	CUR_ROLE=`whoami`
	if [ "uxdb" != $CUR_ROLE ]; then
        	UXDB_ROLE=`egrep "^uxdb" /etc/passwd`
	        if [[ -z $UXDB_ROLE ]]; then
        	        echo "Please create user \"uxdb\" first!"
	        else
        	        echo "Permission denied,please \"su - uxdb\" before install!"
	        fi
	        exit 1
	fi

	UXDBPATH=/home/uxdb/uxdbinstall
	initdbresult=10

	echo -e "Init uxdbwebdb for uxdbweb server?(y/n)[y]:\c"
	read init_str
	if [[ -z $init_str || "y" = $init_str || "Y" = $init_str ]]; then
		initwebdb
	fi
	if [[ 10 -ne $initdbresult && 0 -ne $initdbresult ]]; then
		echo "Uxdbwebdb init faild!"
		exit 1
	fi

	echo -e "Start uxdbwebdb for uxdbweb server?(y/n)[y]:\c"
	read start_str
	if [[ -z $start_str || "y" = $start_str || "Y" = $start_str ]]; then
		startwebdb
	fi
}
uxdbwebdb

#!/bin/bash

DEFAULT_INSTALL_PATH="/home/uxdb/uxdbinstall/uxdbweb"
DEFAULT_ROLE="uxdb"
DEFAULT_ERR_LOG="/home/uxdb/uxdbinstall/errorUninstall.log"

#checkout user

	ID=`id | awk -F\( '{ print substr($2, 1, index($2, ")") - 1) }'`
	if [ "$ID" != "uxdb" ] ; then
		if [ ! -s "/home/uxdb" ] ; then
			echo "uxdb user not exit,please adduser \"$uxdbUser\" first,then su - "$DEFAULT_ROLE" !"
			exit 1;
		fi

		echo -e "Error : You should have uxdb privilege!first su "$DEFAULT_ROLE""
		echo -e "        Exit installation.."
		echo -e "Error : User $ID has no privilege to install."
		exit 1;
	fi
#checkout default_install_path
	if [ ! -d "$DEFAULT_INSTALL_PATH" ];then
                echo "you are not install uxdbweb!"
		exit 1
        fi
#checkout process exist?	
    read -p "do you want to uninstall uxdbweb?[Y/N]:" flag
    if [[ "$flag" == "Y" || "$flag" == "y" ]];then
	    process=$( ps -ef | grep "uxweb.jx" | grep -v "grep" | awk '{print $2}')
            if [ -n "$process" ];then
                echo "uxdbweb is running! please stop uxdbweb first!"
		exit 1
	    fi	
	    tmp=3
	    while [ "$tmp" != 0 ]
	    do
		read -p "please input install dirctory["$DEFAULT_INSTALL_PATH"]:" installDir
		if [ -z "$installDir" ];then
		    installDir="$DEFAULT_INSTALL_PATH"
		    break
		fi
				
		if [ ! -s "$installDir" ];then
			echo "$installDir isnot a dirctory!please input again!:"
			let tmp--
		else
			installDir="$installDir"
			break						
		fi
		if [ 0 -eq $tmp ];then
                     break
		fi	
	    done
                chmod -R 755 "$installDir"
                rm -rf "$installDir" 2>"$DEFAULT_ERR_LOG"
                if [ $? -eq 0 ];then
			    echo "uninstall uxdbweb success"
                     if [ -n "$DEFAULT_ERR_LOG" ];then
                         rm -rf "$DEFAULT_ERR_LOG"  
		     fi
                else
                     echo `cat $"DEFAULT_ERR_LOG"`
                     echo "uninstall uxdbweb faild"
                     if [ -n "$DEFAULT_ERR_LOG" ];then
                         rm -rf "$DEFAULT_ERR_LOG"  
		     fi
                     exit 1				
		fi    		
     fi	
	

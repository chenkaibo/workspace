#! /bin/bash
VISION=4.2.3
OS_NAME=`uname -s`
OS_VER=`uname -r`
OS_PLATFORM=`uname -i`
BUILD_OS_PLATFORM=x86_64

uxdbUser=uxdb
defaultPath=/home/uxdb/uxdbinstall/uxdbweb
##########################
# Check System Information
#  - Check OS Name & OS Version



check_os_info()
{
	# Check OS Name
	#if [ "$OS_NAME" != "Linux" ]; then
	#	echo -e "Error : It is only for Linux."
	#	echo -e "        Exit installation.."
	#	echo -e "Error : Unsupported OS Name $OS_NAME."
	#	exit 1;
	#fi

	# Check OS Version
	IFSUPPORT=`grep ${OS_VER:0:6} platform`
	
	if [ -z "$IFSUPPORT" ]; then
		echo -e "Error : Unsupported OS Release Version $OS_VER."
		echo -e "        Exit installation.."
		echo -e "Error : Unsupported OS Release Version $OS_VER."
		exit 1;
	fi
	
	# Check OS Platform
	if [ "$OS_PLATFORM" != "$BUILD_OS_PLATFORM" ]; then
		echo -e "Error : Unsupported OS PLATFORM $OS_PLATFORM."
		echo -e "        Exit installation.."
		echo -e "Error : Unsupported OS PLATFORM $OS_PLATFORM."
		exit 1;
	fi

	echo -e "  .. Target OS : $OS_NAME $OS_VER $OS_PLATFORM\n"
}

#checkout user

ID=`id | awk -F\( '{ print substr($2, 1, index($2, ")") - 1) }'`
if [ "$ID" != "uxdb" ] ; then
    if [ ! -s "/home/uxdb" ] ; then
		echo "uxdb user not exit,please adduser \"$uxdbUser\" first,then "su - $uxdbUser" !"
		exit 1;
	fi

	echo -e "Error : You should have uxdb privilege!first su "$uxdbUser""
	echo -e "        Exit installation.."
	echo -e "Error : User $ID has no privilege to install."
	exit 1;
fi

##################################

check_os_info

# Setup Log File
INSTALL_LOG=install.log
if [ -f "$INSTALL_LOG" ] ; then
	rm -f $INSTALL_LOG
	touch $INSTALL_LOG
fi


./GetId

echo "please entre the serial number: "
read str1;

./SerialNumber $str1
OP_MODE=$?

tmp=3;
while [ $OP_MODE != 0 ];do
	let tmp--;
	
	if [ "$tmp" -ge 1 ];then	
	echo "the serial number is not valide,please retry, you have $tmp more times:"	
	read str1;
	./SerialNumber $str1
	OP_MODE=$?
	fi
	
	if [ $tmp == 0 ];then
	exit 1;
	fi
done


#prompt install

read -p "Do you want to install uxdbweb?[Y/N]:" inputInstalluxdbweb
if [ -z "$inputInstalluxdbweb" || $"inputInstalluxdbweb" == "y" ] ; then
	inputInstalluxdbweb=Y
fi

#checkout process exist?

process=$( ps -ef | grep "java" | awk '{print $2}')
if( -n "$process" );then
    kill -9 "$process"
    echo "uxdbweb already install,please uninstall uxdbweb first"
	exit 1
fi	
#get installDir(default:/home/uxdb/uxdbinstall/uxdbweb)

if [ "$inputInstalluxdbweb" == "Y" ] ; then

	read -p "uxdbweb install dir[/home/uxdb/uxdbinstall/uxdbweb]!" installDir
	
	#checkout installDir exist?
	
	if [ -s "$installDir" ];then
	    read -p "uxdbweb already install!should delete all file in this dirctory?[Y/N]" flag
		if [ -z "$flag" || $"flag" == "y" ] ; then
	        flag=Y
			if [ "$flag" == "Y" ];then
				rm -rf $installDir/node/
				rm -rf $installDir/uxdbweb/
			fi
        else
            exit 1		
		fi
	elif [ -z "$install" ];then
        installDir="$defaultPath"	
	else
        mkdir $installDir		
	fi
	
	chmod 740 $installDir
	chown -R $uxdbUser:$uxdbUser $installDir
	
	mkdir $installDir/node/
	mkdir $installDir/uxdbweb/
	
	tar -xvf uxdbweb.tar.gz -C $installDir/node/
    tar -xvf node-v"$VISION"-linux-x64.tar.gz -C $installDir/uxdbweb/
    
    if [ -e ./uxwebconfig.json ]; then
	   cp -f uxwebconfig.json $installDir/uxdbweb/
    fi
    if [ -e ./uninstall.sh ]; then
	   cp -f uninstall.sh $installDir/uxdbweb/
    fi
    if [ -e ./start_web.sh ]; then
	   cp -f start_web.sh $installDir/uxdbweb/
    fi	
	if [ -e ./initwebdb.sh ]; then
	   cp -f initwebdb.sh $installDir/uxdbweb/
    fi
	if [ -e ./createuser.sh ]; then
	   cp -f createuser.sh $installDir/uxdbweb/
    fi
fi

if [ 0 -eq $? ];then
    echo -e "Install uxdbweb success!"
else
    echo -e "Install uxdbweb faild!"
fi	


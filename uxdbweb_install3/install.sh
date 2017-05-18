#!/bin/bash
VISION=4.2.3
OS_NAME=`uname -s`
OS_VER=`uname -r`
OS_PLATFORM=`uname -i`
BUILD_OS_PLATFORM=x86_64

uxdbUser="uxdb"

defaultPath="/home/uxdb/uxdbinstall/uxdbweb"
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
		echo "uxdb user not exit,please adduser \"$uxdbUser\" first,then su - "$uxdbUser" !"
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

while [ "$tmp" -gt 0 ];do

	let tmp--;
        read -p "Do you want to install uxdbweb?[Y/N]:" inputInstalluxdbweb
        if [[ -z "$inputInstalluxdbweb" || "$inputInstalluxdbweb" == "y" || "$inputInstalluxdbweb" == "Y" ]];then
	     inputInstalluxdbweb="Y"
	     break
	elif [[ "$inputInstalluxdbweb" == "n" || "$inputInstalluxdbweb" == "N" ]];then
	     exit 1         
        else
	     echo "illegal input! please input again"	
        fi

	if [ $tmp -eq 0 ];then
	   echo "illegal input more than 3 times and exit!"
           exit 1
	fi
done	

#get installDir(default:/home/uxdb/uxdbinstall/uxdbweb)

if [ "$inputInstalluxdbweb" == "Y" ];then
       
        #checkout process exist?
	 
        process=$( ps -ef | grep "uxweb.jx" | grep -v "grep" | awk '{print $2}')
        if [ -n "$process" ];then
	     echo "uxdbweb already install,please uninstall uxdbweb first"
             exit 1
        fi 
     while : ;do    
	read -p "please input uxdbweb install dirctory[/home/uxdb/uxdbinstall/uxdbweb]:" installDir
	
	#checkout installDir exist?
	#如果没输入则为默认路径
        if [ -z "$installDir" ];then
	  if [[ -d "$defaultPath" ]];then
	    read -p "uxdbweb already exist!remove all file from uxdbweb?[Y/N]:" flag
		if [[ -z "$flag" || "$flag" == "y" || "$flag" == "Y" ]];then
            	        flag2="Y"
			if [ "$flag2" == "Y" ];then
				chmod -R 755 $defaultPath
			#	rm -rf $installDir/node
				rm -rf $defaultPath/uxdbweb
				echo "old uxdbweb has bean delete!"
                                installDir=$defaultPath
				break                        
			else
                             exit 1
			fi
		else
			exit 1	     		
		fi
	  else
		  installDir=$defaultPath
		  break	
	  fi	
	else
	    if [ -d "$installDir" ];then
	
	       rm -rf "$installDir"	     	
               mkdir -p $installDir
	       if [ "$?" != 0 ];then
                    echo "illgeal input install dirctory!please input again:"
	       else
		       installDir="$installDir"
		       break	    
	       fi
	    else
		    mkdir -p $installDir
		    break   	    
	    fi   		
	fi	
     done	
#	mkdir $installDir/node/
	mkdir -p $installDir/uxdbweb/
	        
	read -p "uxdbweb will install "$installDir"[Y/N]:" installFlag
        if [[ -z "$installFlag" || "$installFlag" == "y" || "$installFlag" == "Y" ]];then

	     chmod -R 740 $installDir
	     chown -R $uxdbUser:$uxdbUser $installDir
	
 #	     tar -xvf uxdbweb.tar.gz -C $installDir
 #            tar -xvf node-v"$VISION"-linux-x64.tar.gz -C $installDir/node
             

	     if [ -e ./uninstall ]; then
                    cp -f ./uninstall $installDir
             fi
		       
	     if [ -e ./start_web ]; then
	            cp -f ./start_web $installDir
	     fi
             if [ -e ./stop_web ];then
		    cp -f ./stop_web $installDir
             fi		     
	     if [ -e ./initwebdb ]; then
	            cp -f ./initwebdb $installDir
             fi
		       
             if [ -e ./createuser ]; then    
		    cp -f ./createuser $installDir
	     fi
	     if [ -e ./watchdog ];then
		    cp -f ./watchdog $installDir
	     fi
	     if [ -e ./watchdogstart ];then
		    cp -f ./watchdogstart $installDir
             fi		     

	     dd if=uxdbweb_install.des3 |openssl des3 -d -k uxdbweb20170420 | tar zxf - -C $installDir/uxdbweb
	     result=$?
	else 
	        exit 1	     
        fi
fi

if [ $result -eq 0 ];then
    echo -e "Install uxdbweb success!"
    read -p "do you want to excute initwebdb?[Y/N]:" flagInit
    if [[ -z "$flagInit" || "$flagInit" == "Y" || "$flagInit" == "y" ]];then
        if [ -s ./initwebdb ];then
           ./initwebdb		   
        fi   
    fi   
    read -p "do you want to createuser?[Y/N]:" flagUser                 
    if [[ -z "$flagUser" || "$flagUser" == "Y" || "$flagUser" == "y" ]];then

	if [ -s ./createuser ];then
	    ./createuser                    
        fi              
    else
          exit 1           
    fi                  
    sed -i '/\/uxdbwebdb /d' /home/uxdb/uxdbinstall/local_dfs/initdb_record.txt
else
    echo -e "Install uxdbweb faild!"
fi	


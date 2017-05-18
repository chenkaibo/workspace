#!/bin/bash
role=`whoami`
if [ "uxdb" != "$role" ] ; then
	echo "Permission denied,please \"su - uxdb\" before install!"
fi

UXDBWEB_INSTALL_DIRECTORY=/home/uxdb/uxdbinstall/uxdbweb
if [ -e $UXDBWEB_INSTALL_DIRECTORY ]; then
	rm -rf $UXDBWEB_INSTALL_DIRECTORY
fi
echo "uninstall successfully"

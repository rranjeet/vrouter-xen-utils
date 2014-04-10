#!/bin/bash

source $(dirname $0)/common_paths.sh

if [ ! -e $REPOFILE_PATH ]
then
    echo "Installing repo..."
    wget -N http://commondatastorage.googleapis.com/git-repo-downloads/repo
    chmod 0755 repo
    mv repo $REPOFILE_PATH
fi

#Checking to see if the repo download is successful
if [ ! -e $REPOFILE_PATH ]
then
   echo "*********************************"
   echo "  Repo installation has failed"
   echo "*********************************"
   exit -1
fi

apt-get update

echo "***************************************************************"
echo "Installing all the required dependencies from the public repo..."
echo "***************************************************************"
PKGS_LIST="scons git chkconfig python-lxml wget gcc patch make unzip flex bison g++ libssl-dev autoconf automake libtool pkg-config vim python-dev python-setuptools screen libexpat-dev libgettextpo0 libcurl4-openssl-dev  libevent-dev libxml2-dev libxslt-dev uml-utilities python-pip"

for pkg in $PKGS_LIST; do
    if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; 
    then
        echo -e "$pkg is already installed"
    else
        echo "*********Installing package $pkg ***************"
        apt-get -qq install $pkg
        if [ "$?" -ne "0" ]
        then
            echo "*********Installing package $pkg failed***************"
            exit
        fi
        echo "Successfully installed $pkg"
    fi
done
add-apt-repository -y ppa:rwky/redis
apt-get update
apt-get install redis-server

pip install --upgrade setuptools
pip install gevent geventhttpclient==1.0a thrift
pip install kombu
pip install netifaces fabric argparse
pip install stevedore xmltodict python-keystoneclient
pip install kazoo pyinotify
pip install bottle


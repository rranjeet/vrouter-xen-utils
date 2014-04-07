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

echo "Installing all the required dependencies from the public repo..."
PKGS_LIST="scons git python-lxml wget gcc patch make unzip flex bison g++ libssl-dev autoconf automake libtool pkg-config vim python-dev python-setuptools screen"

for pkg in $PKGS_LIST; do
    if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; 
    then
        echo -e "$pkg is already installed"
    else
        apt-get -qq install $pkg
        if [ "$?" -ne "0" ]
        then
            echo "*********Installing package $pkg failed***************"
            exit
        fi
        echo "Successfully installed $pkg"
    fi
done

apt-get update

make_directory $CONTRAIL_SOURCE
make_directory $CONTRAIL_SOURCE/third_party

pushd .
cd $CONTRAIL_SOURCE

repo init -u git@github.com:Juniper/contrail-vnc
repo sync

python third_party/fetch_packages.py

pip install --upgrade setuptools
pip install gevent geventhttpclient==1.0a thrift

popd

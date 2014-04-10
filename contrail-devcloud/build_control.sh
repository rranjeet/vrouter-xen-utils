#!/bin/bash

set -x
source $(dirname $0)/common_paths.sh

pushd .
cd $CONTRAIL_SOURCE

scons 
if [ "$?" -ne "0" ]
then
    echo "*********Control node compilation has failed***************"
    exit
fi

echo "Installing contrail modules"
pip install --upgrade $(find $CONTRAIL_SOURCE/build/debug -name "*.tar.gz" -print)
 
LIBS="build/lib/libtbb_debug.so.2 build/lib/libthrift.a build/lib/libboost_program_options.so build/lib/libboost_filesystem.so build/lib/libboost_system.so build/lib/liblog4cplus.so"
LIBS+=" build/lib/libcurl.a"
#scons $LIBS

#if [ "$?" -ne "0" ]
#then
#    echo "*********LIBS compilation has failed***************"
#    exit
#fi

#scons build/bin/thrift
#if [ ! -d build/debug/vnsw/agent/openstack ]; then
#    mkdir -p build/debug/vnsw/agent/openstack
#else
#    rm -rf build/debug/vnsw/agent/openstack/gen-py
#    build/bin/thrift -o build/debug/vnsw/agent/openstack -gen py controller/src/vnsw/agent/openstack/instance_service.thrift
#fi
#
#make_directory build/source 
#
#pushd build/source
#if [ ! -f uuid-1.30.tar.gz ]; then
#    wget --no-check-certificate https://pypi.python.org/packages/source/u/uuid/uuid-1.30.tar.gz
#fi
#popd
#
#make_directory build/python_dist 
#
#pushd build/python_dist
#tar -xf ../source/uuid-1.30.tar.gz
#cd uuid-1.30
#python setup.py build
#popd
#
#PYTHON_SITE_LIB=$(python -c "from distutils.sysconfig import get_python_lib; print (get_python_lib())")
#
#make_directory $PYTHON_SITE_LIB/instance_service
#
#cp build/debug/vnsw/agent/openstack/gen-py/instance_service/* $PYTHON_SITE_LIB/instance_service/
#chmod 644 $PYTHON_SITE_LIB/instance_service/*
#
#pushd build/python_dist/uuid-1.30
#python setup.py install -O1 --skip-build --root /
#popd
#

popd


#!/bin/bash

set -x
source $(dirname $0)/common_paths.sh

pushd .
cd $CONTRAIL_SOURCE

scons vrouter
if [ "$?" -ne "0" ]
then
    echo "*********vRouter compilation has failed***************"
    exit
fi
 
#scons src/vnsw/agent:vnswad
if [ "$?" -ne "0" ]
then
    echo "*********VNS Agent compilation has failed***************"
    exit
fi

scons vrouter/utils/
if [ "$?" -ne "0" ]
then
    echo "*********VRouter utils compilation has failed***************"
    exit
fi



LIBS="build/lib/libtbb_debug.so.2 build/lib/libthrift.a build/lib/libboost_program_options.so build/lib/libboost_filesystem.so build/lib/libboost_system.so build/lib/liblog4cplus.so"
LIBS+=" build/lib/libcurl.a"
#scons $LIBS

if [ "$?" -ne "0" ]
then
    echo "*********LIBS compilation has failed***************"
    exit
fi

echo "/usr/lib/contrail" > /etc/ld.so.conf.d/contrail.conf

make_directory /usr/lib/contrail 

scons build/bin/thrift
if [ ! -d build/debug/vnsw/agent/openstack ]; then
    mkdir -p build/debug/vnsw/agent/openstack
else
    rm -rf build/debug/vnsw/agent/openstack/gen-py
    build/bin/thrift -o build/debug/vnsw/agent/openstack -gen py controller/src/vnsw/agent/openstack/instance_service.thrift
fi

make_directory build/source 

pushd build/source
if [ ! -f uuid-1.30.tar.gz ]; then
    wget --no-check-certificate https://pypi.python.org/packages/source/u/uuid/uuid-1.30.tar.gz
fi
popd

make_directory build/python_dist 

pushd build/python_dist
tar -xf ../source/uuid-1.30.tar.gz
cd uuid-1.30
python setup.py build
popd

PYTHON_SITE_LIB=$(python -c "from distutils.sysconfig import get_python_lib; print (get_python_lib())")

make_directory $PYTHON_SITE_LIB/instance_service

cp build/debug/vnsw/agent/openstack/gen-py/instance_service/* $PYTHON_SITE_LIB/instance_service/
chmod 644 $PYTHON_SITE_LIB/instance_service/*

pushd build/python_dist/uuid-1.30
python setup.py install -O1 --skip-build --root /
popd

# copy the libraries
cp build/lib/libtbb_debug.so.2 /usr/lib/contrail/
cp build/lib/libthriftasio.so.0.0.0 /usr/lib/contrail/
cp build/lib/libboost_program_options.so.1.48.0 /usr/lib/contrail/
cp build/lib/libboost_filesystem.so.1.48.0 /usr/lib/contrail/
cp build/lib/libboost_regex.so.1.48.0 /usr/lib/contrail/
cp build/lib/libboost_system.so.1.48.0 /usr/lib/contrail/
cp build/lib/liblog4cplus-1.1.so.7.0.0 /usr/lib/contrail/
cp build/lib/libboost_python.so.1.48.0 /usr/lib/contrail/
cp build/lib/libthrift-0.8.0.so /usr/lib/contrail/

pushd .

cd /usr/lib/contrail
ln -sf libtbb_debug.so.2 libtbb_debug.so
ln -sf libthriftasio.so.0.0.0 libthriftasio.so
ln -sf libboost_program_options.so.1.48.0 libboost_program_options.so
ln -sf libboost_filesystem.so.1.48.0 libboost_filesystem.so
ln -sf libboost_regex.so.1.48.0 libboost_regex.so
ln -sf libboost_system.so.1.48.0 libboost_system.so
ln -sf libboost_python.so.1.48.0 libboost_python.so
ln -sf liblog4cplus-1.1.so.7.0.0 liblog4cplus-1.1.so.7
ln -sf libthrift-0.8.0.so libthrift.so

chmod 755 *
ldconfig
popd

# Installing vRouter and Agent
CONTRAIL_ETC=/etc/contrail
make_directory $CONTRAIL_ETC
make_directory /lib/modules/$(uname -r)/extra/net/vrouter

#Copying the biniaries to the required path.
cp build/debug/vrouter/utils/flow build/debug/vrouter/utils/vif build/debug/vrouter/utils/mirror build/debug/vrouter/utils/mpls build/debug/vrouter/utils/nh build/debug/vrouter/utils/rt build/debug/vrouter/utils/vrfstats build/debug/vrouter/utils/vxlan build/debug/vrouter/utils/dropstats build/debug/vnsw/agent/vnswad /usr/bin/

chmod 755 /usr/bin/flow  /usr/bin/vif /usr/bin/mirror /usr/bin/mpls /usr/bin/nh /usr/bin/rt /usr/bin/vrfstats /usr/bin/vxlan  /usr/bin/dropstats /usr/bin/vnswad
	
cp vrouter/vrouter.ko  /lib/modules/$(uname -r)/extra/net/vrouter/
chmod 755  /lib/modules/$(uname -r)/extra/net/vrouter/vrouter.ko

# Xen install
make_directory /etc/xensource 
make_directory /etc/xensource/scripts
make_directory /opt/contrail
make_directory /opt/contrail/bin
make_directory /opt/contrail/lib
make_directory /opt/contrail/lib/python

popd


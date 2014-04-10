#!/bin/bash

set -x
source $(dirname $0)/common_paths.sh

make_directory /usr/lib/contrail 
make_directory /etc/contrail
make_directory /var/log/contrail

cp -f control_install/* /etc/contrail/

pushd .
cd $CONTRAIL_SOURCE

echo "/usr/lib/contrail" > /etc/ld.so.conf.d/contrail.conf
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

popd


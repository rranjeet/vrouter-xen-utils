#!/bin/bash

source $(dirname $0)/common_paths.sh



chmod 755 ../ovs-vsctl
cp ../ovs-vsctl /opt/contrail/bin/ovs-vsctl
cp ../ovs-vsctl /usr/bin/
cp ../vrouter-ctl /opt/contrail/bin/
cp ../contrail_add_vif /opt/contrail/bin/
cp ../qemu-dm-wrapper /opt/contrail/bin/

chmod 755 /opt/contrail/bin/*

cp ../contrail_lib.py /opt/contrail/lib/python/
chmod 755 /opt/contrail/lib/python/contrail_lib.py

make_directory /opt/contrail/xenserver-scripts/


pushd .
# Configuring the XenServer
cd compute_install
chmod 755 *
admin_br_name=xenbr0
admin_if_name=eth0
controller_ip=192.168.56.30
./contrail-reconf-net.sh $admin_br_name

./contrail-conf-gen-agent.sh ./templ-agent.conf $admin_br_name $controller_ip > /etc/contrail/agent.conf

cp ../../vif-vrouter /etc/xensource/scripts/
ln -sf /etc/xensource/scripts/vif-vrouter /etc/xensource/scripts/vif

cp contrail-vrouter /etc/init.d/
chmod 755 /etc/init.d/contrail-vrouter
sed -i '$ a\'"sleep 5\n/opt/contrail/bin/contrail_add_vif" /etc/init.d/contrail-vrouter
update-rc.d contrail-vrouter defaults

echo openvswitch > /etc/xcp/network.conf

cp xen-contrail-backend.rules /etc/udev/rules.d/
cp xen-contrail-frontend.rules /etc/udev/rules.d/
chmod 755 /etc/udev/rules.d/xen-contrail-backend.rules
chmod 755 /etc/udev/rules.d/xen-contrail-frontend.rules

/etc/init.d/udev restart

popd

sleep 5


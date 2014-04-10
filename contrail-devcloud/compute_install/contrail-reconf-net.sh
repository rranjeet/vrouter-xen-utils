#!/bin/bash

# Get UUIDs
mgmt_uuid=$( xe pif-list management=true params=uuid --minimal )
#net_uuid=$( xe pif-list management=true params=network-uuid --minimal )
#brname=$( xe network-param-get uuid=$net_uuid param-name=bridge )
#echo $brname

# Get IP coordinates
#eth=$brname
eth=$1
source ./defines_ip.sh

# Set static IP coordinates via native XenServer net mgmt tool
xe pif-reconfigure-ip uuid=$mgmt_uuid ip=$ipaddr netmask=$mask \
    gateway=$ipgw mode=static

#xe pif-param-list uuid=$mgmt_uuid


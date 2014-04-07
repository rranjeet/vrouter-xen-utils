#!/bin/bash
#
# The script generates agent config file. The vname entity instance number
# (xenbrN etc.) provided by the user is used for ethN instance number (such 1:1
# mapping is assumed by xapi and we need to enforce this).

usage() {
        echo "Usage:"
        echo "${THISCMD} <template file> <vname> <controller ip>"
}

THISCMD=`basename $0`

# Validate args
if [ -z "$1" -o -z "$2" -o -z "$3" ]; then
        usage
        exit 1
fi

eth=$2

# Get IP coordinates
source ./defines_ip.sh

ethunit=$( echo "$eth" | sed -n -e "s/\(.*\)\([0-9.]\)\+/\2/gp" )
vname="${type}${ethunit}"
eth="eth${ethunit}"
xmppip=$3

sed -e "/\\\$VNAME\\\$/s//$vname/" -e "/\\\$IPADDR\\\$/s//$ipaddr/" \
    -e "/\\\$IPGW\\\$/s//$ipgw/" -e "/\\\$IPPREFIX\\\$/s//$ipprefix/" \
    -e "/\\\$ETH\\\$/s//$eth/" -e "/\\\$XMPPIP\\\$/s//$xmppip/" "$1"


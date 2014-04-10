#!/bin/bash

source $(dirname $0)/common_paths.sh
pushd .
cd $CONTRAIL_SOURCE/third_party
wget -N https://code.grnet.gr/attachments/download/1172/ncclient-v0.3.2.tar.gz
pip install ncclient-v0.3.2.tar.gz
popd 

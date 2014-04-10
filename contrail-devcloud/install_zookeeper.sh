#!/bin/bash

source $(dirname $0)/common_paths.sh
pushd .
cd $CONTRAIL_SOURCE/third_party
wget -N http://apache.mirrors.hoobly.com/zookeeper/stable/zookeeper-3.4.6.tar.gz
tar xvzf zookeeper-3.4.6.tar.gz
cd zookeeper-3.4.6
cp conf/zoo_sample.cfg conf/zoo.cfg

popd 

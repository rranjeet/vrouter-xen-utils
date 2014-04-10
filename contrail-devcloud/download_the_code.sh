#!/bin/bash

source $(dirname $0)/common_paths.sh

make_directory $CONTRAIL_SOURCE
make_directory $CONTRAIL_SOURCE/third_party

pushd .
cd $CONTRAIL_SOURCE

repo init -u git@github.com:Juniper/contrail-vnc
repo sync

python third_party/fetch_packages.py

(cd third_party/thrift-*; touch configure.ac README ChangeLog; autoreconf --force --install)

popd

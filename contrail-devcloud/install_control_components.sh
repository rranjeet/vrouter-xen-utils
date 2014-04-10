#!/bin/bash

set -x
source $(dirname $0)/common_paths.sh

./install_cass.sh
./install_ifmap.sh
./install_ncclient.sh
./install_zookeeper.sh



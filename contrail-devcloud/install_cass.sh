#!/bin/bash

set -x
source $(dirname $0)/common_paths.sh

apt-get install python-software-properties
add-apt-repository -y ppa:nilarimogard/webupd8
apt-get update
apt-get install launchpad-getkeys

# use oracle Java 7 instead of OpenJDK
add-apt-repository -y ppa:webupd8team/java
apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
apt-get install -y oracle-java7-installer

# See http://wiki.apache.org/cassandra/DebianPackaging
echo "deb http://www.apache.org/dist/cassandra/debian 12x main" | \
sudo tee /etc/apt/sources.list.d/cassandra.list
#gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D
#gpg --export --armor F758CE318D77295D | sudo apt-key add -
#gpg --keyserver pgp.mit.edu --recv-keys 2B5C1B00
#gpg --export --armor 2B5C1B00 | sudo apt-key add -
#
apt-get update
apt-get install -y --force-yes --allow-unauthenticated cassandra

service cassandra stop
update-rc.d -f cassandra remove


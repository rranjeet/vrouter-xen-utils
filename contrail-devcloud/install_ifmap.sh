#!/bin/bash

source $(dirname $0)/common_paths.sh
pushd .

cd $CONTRAIL_SOURCE/third_party
wget -N http://trust.f4.hs-hannover.de/download/iron/archive/irond-0.3.0-bin.zip
#unzip irond-0.3.0-bin.zip
chmod -w irond-0.3.0-bin/ifmap.properties

#contrail_users_added=$(grep Contrail irond-0.3.0-bin/basicauthusers.properties)

if ! grep -q "Contrail" "irond-0.3.0-bin/basicauthusers.properties"
then
echo ""
echo "# Contrail users" >> irond-0.3.0-bin/basicauthusers.properties
echo "api-server:api-server" >> irond-0.3.0-bin/basicauthusers.properties
echo "schema-transformer:schema-transformer" >> irond-0.3.0-bin/basicauthusers.properties
echo "svc-monitor:svc-monitor" >> irond-0.3.0-bin/basicauthusers.properties

echo "# Contrail users" >> irond-0.3.0-bin/basicauthusers.properties
echo "api-server:api-server" >> irond-0.3.0-bin/basicauthusers.properties
echo "schema-transformer:schema-transformer" >> irond-0.3.0-bin/basicauthusers.properties
echo "svc-monitor:svc-monitor" >> irond-0.3.0-bin/basicauthusers.properties
echo "192.168.56.30:192.168.56.30" >> irond-0.3.0-bin/basicauthusers.properties
echo "192.168.56.30.dns:192.168.56.30.dns" >> irond-0.3.0-bin/basicauthusers.properties
fi


popd 

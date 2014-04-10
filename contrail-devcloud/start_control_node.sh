#!/bin/bash

#set -x
source $(dirname $0)/common_paths.sh

pushd .

cd $CONTRAIL_SOURCE


SCREEN_NAME=contrail
screen -d -m -S $SCREEN_NAME -t shell -s /bin/bash
sleep 2

redis-cli flushall
echo "Starting the Redis Server...."
screen_it redis "sudo redis-server $REDIS_CONF"

echo "Starting the Cassandra Server...."
screen_it cass "sudo $CASS_PATH -f"

echo "Starting Zookeeper...."
screen_it zk "cd $CONTRAIL_SOURCE/third_party/zookeeper-3.4.6; ./bin/zkServer.sh start"

echo "Starting IFMAP Server...."
screen_it ifmap "cd $CONTRAIL_SOURCE/third_party/irond-0.3.0-bin; java -jar ./irond.jar"
sleep 2
    
echo "Starting Discovery service...."
pywhere discovery
screen_it disco "python $PYWHERE/disc_server_zk.py --reset_config --conf_file /etc/contrail/discovery.conf"

echo "Starting API Server...."
pywhere vnc_cfg_api_server 
#screen_it apiSrv "python $PYWHERE/vnc_cfg_api_server.py --conf_file /etc/contrail/api_server.conf --rabbit_password ${RABBIT_PASSWORD}"
screen_it apiSrv "python $PYWHERE/vnc_cfg_api_server.py --conf_file /etc/contrail/api_server.conf "

echo "Starting Schema Transformer...."
pywhere schema_transformer
screen_it schema "python $PYWHERE/to_bgp.py --reset_config --conf_file /etc/contrail/schema_transformer.conf"

echo "Starting service monitor...."
pywhere svc_monitor
screen_it svc-mon "python $PYWHERE/svc_monitor.py --reset_config --conf_file /etc/contrail/svc_monitor.conf"

echo "Starting Control Node...."
source /etc/contrail/control_param
screen_it control "export LD_LIBRARY_PATH=/usr/lib/contrail/; $CONTRAIL_SOURCE/build/debug/control-node/control-node --IFMAP.server_url https://${IFMAP_SERVER}:${IFMAP_PORT} --IFMAP.user ${IFMAP_USER} --IFMAP.password ${IFMAP_PASWD} --DEFAULT.hostname ${HOSTNAME} --DEFAULT.hostip ${HOSTIP} --DEFAULT.bgp_port ${BGP_PORT} ${CERT_OPTS} ${LOG_LOCAL}"



popd

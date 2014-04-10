#!/bin/bash

REPOFILE_PATH=/usr/bin/repo
CONTRAIL_REPO_PROTO=${CONTRAIL_REPO_PROTO:-ssh}
CONTRAIL_SOURCE=~/contrailsource
REDIS_CONF="/etc/redis/redis.conf"
CASS_PATH="/usr/sbin/cassandra"
PYTHONPATH=$PYTHONPATH:/usr/local/lib/python2.7/dist-packages:/usr/local/lib/python2.7/dist-packages/gevent:/usr/local/lib/python2.7/dist-packages/gevent

make_directory() {
    if [ ! -d $1 ]
    then
        mkdir -p $1
        chmod 0755 $1
    fi
}

screen_it() {
    screen -r "$SCREEN_NAME" -x -X screen -t $1
    screen -r "$SCREEN_NAME" -x -p $1 -X stuff "`printf "$2\\r"`"
    sleep 2
}

pywhere() {
    module=$1
    PYWHERE=$(python -c "import $module; import os; print os.path.dirname($module.__file__)")
}

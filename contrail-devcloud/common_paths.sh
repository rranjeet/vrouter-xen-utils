#!/bin/bash

REPOFILE_PATH=/usr/bin/repo
CONTRAIL_REPO_PROTO=${CONTRAIL_REPO_PROTO:-ssh}
CONTRAIL_SOURCE=~/contrailsource2

make_directory() {
    if [ ! -d $1 ]
    then
        mkdir -p $1
        chmod 0755 $1
    fi
}



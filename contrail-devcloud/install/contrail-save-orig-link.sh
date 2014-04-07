#!/bin/bash

usage() {
        echo "Usage:"
        echo "${THISCMD} <orig file> <new file>"
}

err() {
        echo 1>&2 ${THISCMD}: ERROR: $*
}

THISCMD=`basename $0`

# Validate args
if [ -z "$1" -o -z "$2" ]; then
        usage
        exit 1
fi

if ! [ -f "$1" ]; then
        err "Problem with file: $1"
        exit 1
fi
if ! [ -f "$2" ]; then
        err "Problem with file: $2"
        exit 1
fi

orig=$1
new=$2

mv "$orig" "${orig}.orig"
ln -sf "$new" "$orig"


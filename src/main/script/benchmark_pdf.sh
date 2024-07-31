#!/usr/bin/env bash
#
# Simple benchmark script using h2kiad
#
# Author:	Matteo Franci <mttfranci@gmail.com>
set -e

function print() {
    printf "\033[1;34m$1\033[0m\n"
}

PREFIX=${1}

ARRAY=( "pdf-fop"
        "pdf-ua-fop"
        "pdf-a-fop"
        "openpdf" )

for current in "${ARRAY[@]}" ; do
    ID=${current}
    PORT=8080
    print "Start test ${ID} - ${PORT}"
    ./src/main/script/bench-h2-load.sh http://localhost:${PORT}/doc/pdf/handler/${ID}/simple-test-01.pdf > target/${PREFIX}${ID}.out
    print "End test ${ID} - ${PORT}"
done

#!/usr/bin/env bash
#
# Simple benchmark script using hey and psrecord
#
# Author:	Matteo Franci <mttfranci@gmail.com>
#
# NOTE: this script is based on <https://github.com/alina-yur/native-spring-boot/blob/main/bench-jit-c2.sh>
set -e

function print() {
    printf "\033[1;34m$1\033[0m\n"
}

print "Starting the app 🏎️"

export TEST_URL=http://localhost:8080/doc/pdf/handler/${1}/simple-test-01.pdf
export LOOP_COUNT=50000
export BASE_DIR=target

java -XX:-UseJVMCICompiler -Xmx512m -jar ./${BASE_DIR}/quarkus-app/quarkus-run.jar &
export PID=$!
psrecord $PID --plot "${BASE_DIR}/$(date +%s)-${1}.png" --include-children &

sleep 5
print "Done waiting for startup..."

print "Executing warmup load"
hey -n=${LOOP_COUNT} -c=8 ${TEST_URL}

print "Executing benchmark load"
hey -n=${LOOP_COUNT} -c=8 ${TEST_URL}

print "JVM run done!🎉"
kill $PID
sleep 1

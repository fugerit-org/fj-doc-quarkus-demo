#!/usr/bin/env bash
#
# Simple benchmark script using hey and psrecord
#
# Author:	Matteo Franci <mttfranci@gmail.com>
#
# arguments :
# $1 (required) - handler to use, for instance : pdf-fop, openpdf
# $2 (optional, "") - if different from "" should be the path to write the h2load outputs
# $3 (optional, default 50000) - number of requests
# $4 (optional, default 60) - number of clients
# $5 (optional, default 4) - number of threads
#
# to run this script :
# - clone project : https://github.com/fugerit-org/fj-doc-quarkus-demo
# - from the project root : 'mvn clean package' (requires jdk 21)
# - run : ./src/main/script/bench-graph-h2-load.sh pdf-fop
#
# NOTE: this script is based on <https://github.com/alina-yur/native-spring-boot/blob/main/bench-jit-c2.sh>
set -e

function print() {
    printf "\033[1;34m$1\033[0m\n"
}

print "Starting the app 🏎️"

# the handler
export HANDLER=${1}
if [[ "${HANDLER}" = "" ]]; then
  echo "Missing required argument (1) - handler"
  exit 1
fi

# list of test urls
export URL_PARAM="http://localhost:8080/doc/pdf/handler/${HANDLER}/simple-test-01.pdf http://localhost:8080/doc/pdf/handler/${HANDLER}/simple-test-02.pdf http://localhost:8080/doc/pdf/handler/${HANDLER}/simple-test-03.pdf"
export LOG_FILE=${2}
export NUMBER_OF_REQUESTS=${3:-50000}
export NUMBER_OF_CLIENTS=${4:-60}
export NUMBER_OF_THREADS=${5:-4}
export BASE_DIR=target
export WARMUP_REQUESTS=1000

echo "Running with arguments : HANDLER=${HANDLER}, NUMBER_OF_REQUESTS=${NUMBER_OF_REQUESTS}, NUMBER_OF_CLIENTS=${NUMBER_OF_CLIENTS}, URL_PARAM=${URL_PARAM}"

java -XX:-UseJVMCICompiler -Xmx512m -jar ./${BASE_DIR}/quarkus-app/quarkus-run.jar &
export PID=$!
psrecord $PID --plot "${BASE_DIR}/$(date +%s)-${HANDLER}.png" --include-children &

sleep 8
print "Done waiting for startup..."

print "Executing warmup load : ${WARMUP_REQUESTS}"
h2load -n${WARMUP_REQUESTS} -c${NUMBER_OF_CLIENTS} -t${NUMBER_OF_THREADS} --warm-up-time=2 ${URL_PARAM}

print "Executing benchmark load : ${NUMBER_OF_REQUESTS}"
if [[ "${LOG_FILE}" = "" ]]; then
  h2load -n${NUMBER_OF_REQUESTS} -c${NUMBER_OF_CLIENTS} -t${NUMBER_OF_THREADS} --warm-up-time=2 ${URL_PARAM}
else
  echo "Write output to log file : ${LOG_FILE}"
  h2load -n${NUMBER_OF_REQUESTS} -c${NUMBER_OF_CLIENTS} -t${NUMBER_OF_THREADS} --warm-up-time=2 ${URL_PARAM} > ${LOG_FILE} 2>&1
fi


print "JVM run done!🎉"
kill $PID
sleep 1

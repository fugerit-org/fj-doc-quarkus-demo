#!/usr/bin/env bash
#
# Simple benchmark script using hey and psrecord
#
# Author:	Matteo Franci <mttfranci@gmail.com>
#
# arguments :
# $1 (required) - handler to use, for instance : pdf-fop, openpdf
# $2 (optional, default 50000) - number of requests
# $3 (optional, default 60) - number of clients
# $4 (optional, default 4) - number of threads
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

# check if h2load is installed
if [ ! -x "$(command -v h2load)" ]; then
  echo "Missing h2load, please install nghttp2"
  echo "On MacOS : brew install nghttp2"
  echo "On Ubuntu/Debian based : apt-get install nghttp2-client"
  echo "On Fedora/RPM based : dnf install nghttp2"
  echo "For more info : https://nghttp2.org/documentation/package_README.html"
  exit 1
fi

# the handler
export HANDLER=${1}
if [[ "${HANDLER}" = "" ]]; then
  echo "Missing required argument (1) - handler"
  exit 1
fi

# list of test urls
export URL_PARAM="http://localhost:8080/doc/pdf/handler/${HANDLER}/simple-test-01.pdf http://localhost:8080/doc/pdf/handler/${HANDLER}/simple-test-02.pdf http://localhost:8080/doc/pdf/handler/${HANDLER}/simple-test-03.pdf"
export OUTPUT_BASE=${HANDLER}
export NUMBER_OF_REQUESTS=${2:-50000}
export NUMBER_OF_CLIENTS=${3:-60}
export NUMBER_OF_THREADS=${4:-4}
export BASE_DIR=target
export WARMUP_REQUESTS=1000

# check if quarkus-run.jar exists
if [ ! -f ./${BASE_DIR}/quarkus-app/quarkus-run.jar ]; then
  echo "Missing quarkus-run.jar, please run 'mvn clean package' first"
  exit 2
fi

echo "Running with arguments : HANDLER=${HANDLER}, NUMBER_OF_REQUESTS=${NUMBER_OF_REQUESTS}, NUMBER_OF_CLIENTS=${NUMBER_OF_CLIENTS}, URL_PARAM=${URL_PARAM}"

java -Xmx1024m -jar ./${BASE_DIR}/quarkus-app/quarkus-run.jar &
export PID=$!
if [ -x "$(command -v psrecord)" ]; then
  echo "psrecord installed, plotting process : ${PID}"
  psrecord $PID --plot "${BASE_DIR}/out_${OUTPUT_BASE}.png" --include-children &
else
  echo "psrecord not installed, plotting skipped for process : ${PID}"
fi

sleep 8
print "Done waiting for startup..."

print "Executing warmup load : ${WARMUP_REQUESTS}"
h2load -n${WARMUP_REQUESTS} -c${NUMBER_OF_CLIENTS} -t${NUMBER_OF_THREADS} --warm-up-time=2 ${URL_PARAM}

print "Executing benchmark load : ${NUMBER_OF_REQUESTS}"
h2load -n${NUMBER_OF_REQUESTS} -c${NUMBER_OF_CLIENTS} -t${NUMBER_OF_THREADS} --warm-up-time=2 ${URL_PARAM} > ${BASE_DIR}/out_${OUTPUT_BASE}.log 2>&1


print "JVM run done!🎉"
kill $PID
sleep 1

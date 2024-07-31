#!/usr/bin/env bash
#
# Simple benchmark script using h2load
#
# Author:	Matteo Franci <mttfranci@gmail.com>
set -e

NUMBER_OF_REQUESTS=10000
NUMBER_OF_CLIENTS=60
NUMBER_OF_THREADS=4

function print() {
    printf "\033[1;34m$1\033[0m\n"
}

export URL_PARAM="${1}"

if [[ "${URL_PARAM}" == "" ]]; then
  echo "url param must be provided, for instance http://localhost:8080/doc/pdf/handler/openpdf/simple-test-01.pdf"
else
  print "Starting benchmark for '${URL_PARAM}' 🏎️"
  echo "URL_PARAM : ${URL_PARAM}"
  h2load -n${NUMBER_OF_REQUESTS} -c${NUMBER_OF_CLIENTS} -t${NUMBER_OF_THREADS} --warm-up-time=2 ${URL_PARAM}
  print "Benchmark over for '${URL_PARAM}' 🏎️"
fi

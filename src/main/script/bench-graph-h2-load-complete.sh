#!/usr/bin/env bash
#
# Run benchmark on all doc handlers
#
# Author:	Matteo Franci <mttfranci@gmail.com>

BASE_DIR=target
echo "1. Maven clean package"
mvn clean package > ${BASE_DIR}/benchmark_log.txt 2>&1
HANDLERS=(pdf-fop pdf-fop-pool openpdf)
echo "2. Running benchmark"
for docHandler in ${HANDLERS[@]}; do
  echo "Current doc handler : ${docHandler}"
  ./src/main/script/bench-graph-h2-load.sh ${docHandler} >> ${BASE_DIR}/benchmark_log.txt 2>&1
done

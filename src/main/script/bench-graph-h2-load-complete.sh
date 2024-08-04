#!/usr/bin/env bash
#
# Run benchmark on all doc handlers
#
# Author:	Matteo Franci <mttfranci@gmail.com>

# environments :
# NO_START - if set to '1' quarkus will not be started and no plotting will be performed

BASE_DIR=target
echo "1. Maven clean package"
if [ "${NO_START}" = "1" ]; then
  echo "NO_START build skipped" > ${BASE_DIR}/benchmark_log.txt 2>&1
else
  mvn clean package > ${BASE_DIR}/benchmark_log.txt 2>&1
fi
HANDLERS=(pdf-fop pdf-fop-pool openpdf)
echo "2. Running benchmark"
for docHandler in ${HANDLERS[@]}; do
  echo "Current doc handler : ${docHandler}"
  ./src/main/script/bench-graph-h2-load.sh ${docHandler} >> ${BASE_DIR}/benchmark_log.txt 2>&1
done

# fj-doc-quarkus-demo

Simple demo application to test performances of [Fugerit Venus Doc](https://github.com/fugerit-org/fj-doc) library.

[![Keep a Changelog v1.1.0 badge](https://img.shields.io/badge/changelog-Keep%20a%20Changelog%20v1.1.0-%23E05735)](CHANGELOG.md)
[![license](https://img.shields.io/badge/License-MIT%20License-teal.svg)](https://opensource.org/license/mit)
[![code of conduct](https://img.shields.io/badge/conduct-Contributor%20Covenant-purple.svg)](https://github.com/fugerit-org/fj-doc-quarkus-demo/blob/main/CODE_OF_CONDUCT.md)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=fugerit-org_fj-doc&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=fugerit-org_fj-doc)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=fugerit-org_fj-doc&metric=coverage)](https://sonarcloud.io/summary/new_code?id=fugerit-org_fj-doc)

[![Java version](https://img.shields.io/badge/JD-java%2021+-%23113366.svg?style=for-the-badge&logo=openjdk&logoColor=white)](https://universe.fugerit.org/src/docs/versions/java21.html)
[![Apache Maven](https://img.shields.io/badge/Apache%20Maven-3.9.0+-C71A36?style=for-the-badge&logo=Apache%20Maven&logoColor=white)](https://universe.fugerit.org/src/docs/versions/maven3_9.html)
[![Fugerit Github Project Conventions](https://img.shields.io/badge/Fugerit%20Org-Project%20Conventions-1A36C7?style=for-the-badge&logo=Onlinect%20Playground&logoColor=white)](https://universe.fugerit.org/src/docs/conventions/index.html)

Here you can find [quarkus original readme](README_QUARKUS.md).

## Quickstart

After clone, from the project root : 

### 1. Build

```shell
mvn clean package
```

### 2. Run benchmark script

```shell
./src/main/script/bench-graph-h2-load.sh pdf-fop '' 1000
```

**The script accepts these positional arguments :**

| position               | required | default | description                                                                   |
|------------------------|----------|---------|-------------------------------------------------------------------------------|
| 1 (HANDLER)            | true     |         | handler id : 'pdf-fop', 'pdf-fop-pool', 'pdf-a-fop', 'pdf-ua-fop' , 'openpdf' |
| 2 (LOG_FILE)           | false    |         | If different from "" should be the path to write the h2load outputs           |
| 3 (NUMBER_OF_REQUESTS) | false    | 50000   | Total number of requests to run (h2load -n)                                   |
| 4 (NUMBER_OF_CLIENTS)  | false    | 60      | Number of concurrent clients (h2load -c)                                      |
| 5 (NUMBER_OF_THREADS)  | false    | 4       | Number of concurrent threads (h2load -t)                                      |

**Currenlty configured pdf handlers :**

- *pdf-fop* - vanilla [pdf fop handler](https://github.com/fugerit-org/fj-doc/tree/main/fj-doc-mod-fop)
- *pdf-fop-pool* - [pdf fop handler with pooling](https://github.com/fugerit-org/fj-doc/tree/main/fj-doc-mod-fop) (min:20, max:40)
- *pdf-a-fop* - [pdf-a fop handler](https://github.com/fugerit-org/fj-doc/tree/main/fj-doc-mod-fop)
- *pdf-a-fop* - [pdf-ua fop handler](https://github.com/fugerit-org/fj-doc/tree/main/fj-doc-mod-fop)
- *openpdf* - [openpdf handler](https://github.com/fugerit-org/fj-doc/tree/main/fj-doc-mod-openpdf-ext)

It is possible to change doc handlers configuration from the [freemarker-doc-process.xml](src/main/resources/fj-doc-demo-config/freemarker-doc-process.xml) XML configuration.

## Benchmark suit

This script run benchmark on all doc handlers and write the output to *target/* folder.


#!/bin/bash

NEW="${1:-/opt/gopath/src/github.com/hashicorp/nomad/bin/nomad}"
TARGET="${2:/opt/gopath/bin}"

cp ${NEW} ${TARGET}

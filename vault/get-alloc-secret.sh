#!/bin/bash


allocID="${allocID:=devkit}"

echo "certificate ==>"
nomad alloc exec -task "task" $allocID cat "/secrets/certificate.crt"

echo "key ==>"
nomad alloc exec -task "task" $allocID cat "/secrets/access.key"

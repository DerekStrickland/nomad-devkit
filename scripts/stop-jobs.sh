#!/usr/bin/env bash

for job in $(nomad job status | tail +1 | awk -F' +' '{print $1}')
do
    nomad job stop -purge $job
done

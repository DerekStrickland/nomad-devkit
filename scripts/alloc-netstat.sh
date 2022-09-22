#!/bin/bash

# Example usage with the basic job  ./scripts/alloc-netstat.sh f6b05518 cache
nomad alloc status $1 | grep -A 3 'Allocation Addresses'

nomad alloc exec -task $2 $1 /bin/sh -c 'netstat -tulpn'

nomad alloc exec -task $2 $1 /bin/sh -c 'cat /proc/net/tcp' grep -v "rem_address" /proc/net/tcp  | awk  '{x=strtonum("0x"substr($3,index($3,":")-2,2)); for (i=5; i>0; i-=2) x = x"."strtonum("0x"substr($3,i,2))}{print x":"strtonum("0x"substr($3,index($3,":")+1,4))}'

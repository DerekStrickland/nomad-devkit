curl $NOMAD_ADDR/v1/job/$1/allocations | jq -r '.[].Name'

nomad alloc status -json $1 | jq -r '.TaskStates | keys[] as $k | "{\"Name\": \"\($k)\", \"FinishedAt\": \"\(.[$k] | .FinishedAt)\"}"' | jq -s -c 'sort_by(.FinishedAt) | .[]' | jq 

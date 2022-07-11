#!/bin/sh

ID="${ID:=devkit}"
TTL="${TTL:=10s}"

secretsPath="${ID}-secrets"
pkiPath="${ID}-pki"

echo $secretsPath
echo $pkiPath

# create secrets policy
policyID="access-secrets-${ID}"

vault policy write $policyID -<<POLICYDOC
path "$secretsPath/data/myapp" {
  capabilities = ["read"]
}

path "$pkiPath/issue/nomad" {
  capabilities = ["create", "update", "read"]
}
POLICYDOC

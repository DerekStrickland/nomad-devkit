#!/bin/sh

ID="${ID:=devkit}"
TTL="${TTL:=10s}"

secretsPath="${ID}-secrets"
pkiPath="${ID}-pki"

echo $secretsPath
echo $pkiPath

# configure KV secrets engine
# Note: the secret key is written to 'secret-###/myapp' but the kv2 API
# for Vault implicitly turns that into 'secret-###/data/myapp' so we
# need to use the longer path for everything other than kv put/get
vault secrets enable -path=$secretsPath kv-v2

vault kv put $secretsPath/myapp key=$ID

vault secrets tune -max-lease-ttl=1m $secretsPath

# configure PKI secrets engine
vault secrets enable -path=$pkiPath pki

vault write $pkiPath/root/generate/internal common_name=service.consul ttl=1h

vault write $pkiPath/roles/nomad \
    allowed_domains=service.consul \
    allow_subdomains=true \
    generate_lease=true \
    max_ttl=1m

vault secrets tune -max-lease-ttl=1m $pkiPath

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

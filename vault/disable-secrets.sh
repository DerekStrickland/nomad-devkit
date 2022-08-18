#!/bin/sh

ID="${ID:=devkit}"

secretsPath="${ID}-secrets/"
pkiPath="${ID}-pki/"

echo $secretsPath
echo $pkiPath

vault secrets disable $secretsPath
vault secrets disable $pkiPath


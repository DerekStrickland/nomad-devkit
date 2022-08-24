#!/bin/bash


nomad job stop -purge vault-secrets-noop
nomad job stop -purge vault-secrets-restart
nomad job stop -purge vault-secrets-kill
sleep 5
vault/disable-secrets.sh
sleep 2
vault/enable-secrets.sh
sleep 2
nomad run jobs/template/vault-secrets-noop.nomad
nomad run jobs/template/vault-secrets-restart.nomad
nomad run jobs/template/vault-secrets-kill.nomad
nomad status

## Usage

These scripts allow you run a local nginx proxy to the Nomad or Consul UI running on any infrastructure. We use this approach to attach to our E2E clusters running in AWS for manual testing or test debugging. For a development or testing environment, it is possible to share certs and keys. You should never do this in a production environment.

## Nomad

- `NOMAD_ADDR`: must be set to a reachable address of a Nomad server
- `NOMAD_CACERT`: path to the Nomad CA cert used by your cluster
- `NOMAD_CLIENT_CERT`: path to a valid client cert
- `NOMAD_CLIENT_KEY`: path to a valid client key

For more details, see this [this tutorial](https://learn.hashicorp.com/tutorials/nomad/security-enable-tls).

## Consul

- `CONSUL_HTTP_ADDR`: must be set to a reachable address of a Consul server
- `CONSUL_CACERT`: path to the Consul CA cert used by your cluster
- `CONSUL_CLIENT_CERT`: path to a valid client cert
- `CONSUL_CLIENT_KEY`: path to a valid client key

## Vault

TODO

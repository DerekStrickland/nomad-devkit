#!/bin/bash

# Use this command to add the a registry if you want to use some other registry than default.
# nomad-pack registry add some-private-registry github.com/<some-org>/<some-pack-registry>

nomad-pack run prometheus -f prometheus.hcl

# The grafana pack does not include a way to inject constraints from a variables file.
# I used `nomad-pack render` to generate a job file and the manually updated it to
# always run on `node-client-1` since, by convention, I don't test error conditions
# on that node.
nomad run grafana.nomad 

# The loki pack has some issues with port mapping, and in addtion the vector pack
# requires well known addresses to be mapped to the host. It does not seem to be
# able to use consul service discovery.
nomad run loki.nomad

nomad-pack run vector -f vector.hcl

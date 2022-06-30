#!/bin/bash

nodes=(
nomad-server01
nomad-server02
nomad-server03
nomad-client01
nomad-client02
)

echo "==> Stopping nomad on all nodes..."
# First, stop nomad on all nodes and clean the data dir
for i in "${nodes[@]}"
do
   (cd ~/code/nomad && vagrant ssh $i -c "hostname; sudo systemctl stop nomad")
done

echo "==> Rebuilding nomad binary..."

(cd ~/code/nomad && vagrant ssh ${nodes[0]} -c "make dev && bin/nomad -version")

echo "==> Restarting nomad on all nodes"

for i in "${nodes[@]}"
do
   (cd ~/code/nomad && vagrant ssh $i -c "hostname; cp bin/nomad /opt/gopath/bin/nomad && nomad -version && sudo systemctl start nomad")
done

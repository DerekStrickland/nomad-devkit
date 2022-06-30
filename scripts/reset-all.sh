#!/bin/bash

skip_rebuild=$1

nodes=(
nomad-server01
# nomad-server02
# nomad-server03
nomad-client01
nomad-client02
nomad-client03
)

echo "==> Stopping nomad on all nodes..."
# First, stop nomad on all nodes and clean the data dir
for i in "${nodes[@]}"
do
   (cd ~/code/nomad && vagrant ssh $i -c "hostname; sudo systemctl stop nomad")
done

# ref https://linuxconfig.org/bash-script-flags-usage-with-arguments-examples
while getopts 'bd' OPTION; do
  case "$OPTION" in
    b)
      echo "==> Rebuilding nomad binary..."
      (cd ~/code/nomad && vagrant ssh ${nodes[0]} -c "make dev && bin/nomad -version")
      ;;
    d)
      echo "==> Cleaning data_dirs..."
      for i in "${nodes[@]}"
      do
         (cd ~/code/nomad && vagrant ssh $i -c "hostname; sudo grep /etc/nomad.d/data /proc/mounts | cut -f2 -d\" \" | sort -r | sudo xargs umount -n; sudo rm -rf /etc/nomad.d/data")
         (cd ~/code/nomad && vagrant ssh $i -c "sudo grep /etc/nomad.d/data /proc/mounts | cut -f2 -d\" \" | sort -r | sudo xargs umount -n")
         (cd ~/code/nomad && vagrant ssh $i -c "sudo rm -rf /etc/nomad.d/data")
      done
      ;;
    ?)
      echo "script usage: $(basename \$0) [-b build binary] [-d clean data dir]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

echo "==> Restarting nomad on all nodes..."

for i in "${nodes[@]}"
do
   (cd ~/code/nomad && vagrant ssh $i -c "hostname; cp bin/nomad /opt/gopath/bin/nomad && nomad -version && sudo systemctl start nomad")
done

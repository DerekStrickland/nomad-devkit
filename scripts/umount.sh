grep /etc/nomad.d/data /proc/mounts | cut -f2 -d" " | sort -r | sudo xargs umount -n
sudo rm -rf /etc/nomad.d/data

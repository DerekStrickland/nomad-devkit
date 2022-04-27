cd ~/goland/nomad
vagrant ssh nomad-client02 -c "sudo systemctl stop nomad"
vagrant ssh nomad-client01 -c "sudo systemctl stop nomad"
vagrant ssh nomad-server01 -c "sudo sh /etc/nomad.d/restart.sh"
vagrant ssh nomad-client02 -c "sudo sh /etc/nomad.d/restart.sh"
vagrant ssh nomad-client01 -c "sudo sh /etc/nomad.d/restart.sh"

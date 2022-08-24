#!/bin/sh

nomad run jobs/template/vault-secrets-noop.nomad
nomad run jobs/template/vault-secrets-kill.nomad

# vagrant ssh node-client-2 & block Vault 

sudo iptables -I OUTPUT -p tcp --dport 8200 -j DROP
# No logs show up other than client.vault: stopped
Aug 01 18:50:47 node-client-2 nomad[4501]:     2022-08-01T18:50:47.242Z [DEBUG] client.vault: stopped

# Restarting Nomad seems to take a bit. Long enough for thge agent to transition to Disconnected
# and the Allocations to Unknown. They reconnect without incident though.


# After restarting Nomad, we see token renewal errors
sudo systemctl restart nomad
Aug 01 18:52:53 node-client-2 nomad[5048]:     2022-08-01T18:52:53.478Z [DEBUG] client.vault: renewal error details: req.increment=30 lease_duration=30 renewal_duration=15s
Aug 01 18:52:53 node-client-2 nomad[5048]:     2022-08-01T18:52:53.479Z [ERROR] client.vault: error during renewal of lease or token failed due to a non-fatal error; retrying: error="failed to renew the vault token: context deadline exceeded" period="2022-08-01 18:53:08.478772855 +0000 UTC m=+141.155872625"
Aug 01 18:53:53 node-client-2 nomad[5048]:     2022-08-01T18:53:53.483Z [DEBUG] client.vault: renewal error details: req.increment=30 lease_duration=30 renewal_duration=15s
Aug 01 18:53:53 node-client-2 nomad[5048]:     2022-08-01T18:53:53.484Z [ERROR] client.vault: error during renewal of lease or token failed due to a non-fatal error; retrying: error="failed to renew the vault token: context deadline exceeded" period="2022-08-01 18:54:08.483582251 +0000 UTC m=+201.160682018"
Aug 01 18:56:50 node-client-2 nomad[5145]:     2022-08-01T18:56:50.092Z [DEBUG] client.vault: renewal error details: req.increment=30 lease_duration=30 renewal_duration=15s
Aug 01 18:56:50 node-client-2 nomad[5145]:     2022-08-01T18:56:50.092Z [ERROR] client.vault: error during renewal of lease or token failed due to a non-fatal error; retrying: error="failed to renew the vault token: context deadline exceeded" period="2022-08-01 18:57:05.0922424 +0000 UTC m=+141.215181301"
Aug 01 18:57:50 node-client-2 nomad[5145]:     2022-08-01T18:57:50.096Z [DEBUG] client.vault: renewal error details: req.increment=30 lease_duration=30 renewal_duration=15s
Aug 01 18:57:50 node-client-2 nomad[5145]:     2022-08-01T18:57:50.097Z [ERROR] client.vault: error during renewal of lease or token failed due to a non-fatal error; retrying: error="failed to renew the vault token: context deadline exceeded" period="2022-08-01 18:58:05.096693472 +0000 UTC m=+201.219632371"

# And here is the system status
sudo systemctl status nomad
● nomad.service - "HashiCorp Nomad"
     Loaded: loaded (/etc/systemd/system/nomad.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2022-08-01 18:40:27 UTC; 11s ago
       Docs: https://www.nomadproject.io/
   Main PID: 4501 (nomad)
      Tasks: 36
     Memory: 31.5M
     CGroup: /system.slice/nomad.service
             ├─3858 /usr/local/bin/nomad logmon
             ├─3903 /usr/local/bin/nomad logmon
             ├─4046 /usr/local/bin/nomad docker_logger
             ├─4117 /usr/local/bin/nomad docker_logger
             └─4501 /usr/local/bin/nomad agent -config=/hashibox/defaults/nomad/config/defaults.hcl -config=/>

Aug 01 18:40:27 node-client-2 systemd[1]: This usually indicates unclean termination of a previous run, or se>
Aug 01 18:40:27 node-client-2 systemd[1]: nomad.service: Found left-over process 3903 (nomad) in control grou>
Aug 01 18:40:27 node-client-2 systemd[1]: This usually indicates unclean termination of a previous run, or se>
Aug 01 18:40:27 node-client-2 systemd[1]: nomad.service: Found left-over process 4046 (nomad) in control grou>
Aug 01 18:40:27 node-client-2 systemd[1]: This usually indicates unclean termination of a previous run, or se>
Aug 01 18:40:27 node-client-2 systemd[1]: nomad.service: Found left-over process 4117 (nomad) in control grou>
Aug 01 18:40:27 node-client-2 systemd[1]: This usually indicates unclean termination of a previous run, or se>
Aug 01 18:40:27 node-client-2 systemd[1]: Started "HashiCorp Nomad".
Aug 01 18:40:27 node-client-2 nomad[4501]: ==> Loaded configuration from /hashibox/defaults/nomad/config/defa>
Aug 01 18:40:27 node-client-2 nomad[4501]: ==> Starting Nomad agent...

# If we restart Nomad again, the token renewal errors stop for about 2 minutes, but eventually resume and proc every
# minute.

# Unblock with 
sudo iptables -D OUTPUT -p tcp --dport 8200 -j DROP

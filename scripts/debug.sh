sudo dlv --listen=:7200 --headless=true --api-version=2 --accept-multiclient exec ./bin/nomad agent -- --config=/etc/nomad.d

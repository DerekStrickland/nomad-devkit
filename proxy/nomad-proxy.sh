NOMAD_WS=${NOMAD_ADDR//https:\/\/} && \
envsubst '\$NOMAD_WS' < nomad.nginx.conf.tpl > nomad.nginx.conf


docker run --publish=8081:80 \
    --mount type=bind,source=nomad.nginx.conf,target=/etc/nginx/nginx.conf \
    --mount type=bind,source=nomad-ca.crt,target=/keys/CA.crt \
    --mount type=bind,source=nomad-client.crt,target=/keys/client.crt \
    --mount type=bind,source=nomad-client.key,target=/keys/client.key \
    nginx:latest

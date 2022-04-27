NOMAD_WS=${NOMAD_ADDR//https:\/\/} && \
envsubst '\$NOMAD_WS' < nomad.nginx.conf.tpl > nomad.nginx.conf


docker run --publish=8081:80 \
    --mount type=bind,source=nomad.nginx.conf,target=/etc/nginx/nginx.conf \
    --mount type=bind,source=${NOMAD_CACERT},target=/keys/CA.crt \
    --mount type=bind,source=${NOMAD_CLIENT_CERT},target=/keys/client.crt \
    --mount type=bind,source=${NOMAD_CLIENT_KEY},target=/keys/client.key \
    nginx:latest

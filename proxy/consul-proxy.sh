CONSUL_WS=${CONSUL_HTTP_ADDR//https:\/\/} && \
envsubst '\$CONSUL_WS' < consul.nginx.conf.tpl > consul.nginx.conf

docker run --publish=8082:80 \
    --mount type=bind,source=consul.nginx.conf,target=/etc/nginx/nginx.conf \
    --mount type=bind,source=consul-ca.crt,target=/keys/CA.crt \
    --mount type=bind,source=consul-client.crt,target=/keys/client.crt \
    --mount type=bind,source=consul-client.key,target=/keys/client.key \
    nginx:latest

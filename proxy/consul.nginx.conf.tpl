# consul-nginx.conf
events {}

http {
  server {

    location / {
      proxy_pass https://consul-ws;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_read_timeout 310s;
      proxy_buffering off;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";
      proxy_set_header Origin "${scheme}://${proxy_host}";

      proxy_redirect off;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Nginx-Proxy true;
      proxy_set_header X-Forwarded-Proto https;
      proxy_next_upstream error timeout http_500;
      proxy_ssl_certificate /keys/client.crt;
      proxy_ssl_certificate_key /keys/client.key;
      proxy_ssl_trusted_certificate /keys/ca.crt;
      proxy_ssl_name server.global.nomad;
      proxy_ssl_server_name on;
      proxy_ssl_session_reuse on;
    }
  }

  upstream consul-ws {
    ip_hash;
    server 44.202.78.146:8501
;
  }
}

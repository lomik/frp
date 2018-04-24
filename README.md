# FRP docker image

Docker image for https://github.com/fatedier/frp. Fully configurable through environment variables.

## frps
```bash
$ docker run -d -p 7000:7000 -p 8000:8000 \
  -e "FRPS=1" \
  -e "FRPS_BIND_PORT=7000" \
  -e "FRPS_VHOST_HTTP_PORT=8080" \
  lomik/frp
# ...
# all parameters can be exposed through environment variables
```

## frpc
```bash
$ docker run -d \
  -e "FRPC=1" \
  -e "FRPC_SERVER_ADDR=x.x.x.x" \
  -e "FRPC_SERVER_PORT=7000" \
  -e "FRPC_1_NAME=ssh" \
  -e "FRPC_1_TYPE=tcp" \
  -e "FRPC_1_LOCAL_IP=127.0.0.1" \
  -e "FRPC_1_LOCAL_PORT=22" \
  -e "FRPC_1_REMOTE_PORT=6000" \
  -e "FRPC_2_NAME=web" \
  -e "FRPC_2_TYPE=http" \
  -e "FRPC_2_LOCAL_PORT=80" \
  -e "FRPC_2_CUSTOM_DOMAINS=www.yourdomain.com" \
  lomik/frp
# ...
# all parameters can be exposed through environment variables
```

proxy=127.0.0.1:7890

set -o allexport
NODE_TLS_REJECT_UNAUTHORIZED=0
all_proxy=socks5://$proxy
https_proxy=http://$proxy
http_proxy=$https_proxy
HTTPS_PORXY=$https_proxy
HTTP_PORXY=$http_proxy
set +o allexport

#!/usr/bin/env bash

apt-get update
if ! curl --connect-timeout 2 -m 4 -s https://t.co >/dev/null; then
  export DOWNLOAD_URL="https://mirrors.tuna.tsinghua.edu.cn/docker-ce"
fi
curl -fsSL https://get.docker.com | bash -s docker
systemctl start docker
systemctl enable docker
apt-get install -y docker-compose

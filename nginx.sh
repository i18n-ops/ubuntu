#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

. env.sh
./docker/nginx/setup.sh
sed -i "s/worker_processes [^;]*;/worker_processes $(nproc);/g" /etc/nginx/nginx.conf
systemctl restart nginx

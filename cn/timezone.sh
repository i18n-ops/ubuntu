#!/usr/bin/env bash

set -ex

apt-get install -y tzdata

export TZ=Asia/Shanghai
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ >/etc/timezone

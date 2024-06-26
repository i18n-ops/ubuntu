#!/usr/bin/env bash

set -ex

HOSTS=("c2" "c1" "c0")

PASSWORD=$1

setup_host() {
local HOST=$1
local PASSWORD=$2

ip=$(grep $HOST /etc/hosts | awk '{print $1}')

if [ -z "$ip" ]; then
  ip=$(dig +short "$HOST" | grep '^[.0-9]*$' | head -n 1)
fi

ssh-keygen -R $ip
ssh-keyscan -H $ip >> ~/.ssh/known_hosts

sshpass -p $PASSWORD ssh-copy-id -o StrictHostKeyChecking=no $HOST
rsync -avz ~/.codeium/config.json $HOST:~/.codeium/

ssh -o StrictHostKeyChecking=no $HOST << EOF
echo $HOST | tee /etc/hostname
hostnamectl set-hostname $HOST

HOSTS_LINE="127.0.0.1 $HOST"
if ! grep -q "\$HOSTS_LINE" /etc/hosts; then
    echo "\$HOSTS_LINE" | tee -a /etc/hosts
fi
bash -i -c enable_ipv6
EOF
}

# 遍历每个主机并进行设置
for HOST in "${HOSTS[@]}"; do
  setup_host $HOST $PASSWORD
done



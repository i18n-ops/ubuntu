#!/usr/bin/env bash

set -ex
echo madvise >/sys/kernel/mm/transparent_hugepage/enabled

apt-get install -y zram-config sd

init=/usr/bin/init-zram-swapping

sd '^echo \$mem' 'echo zstd > /sys/block/zram0/comp_algorithm ; echo $$mem' $init
sd '^mem=\$\(.*\)' 'mem=$((totalmem * 1024))' $init

cat $init
echo ''
sysctl_conf=/etc/sysctl.conf

set() {
  sed -i "/^vm.$1/d" $sysctl_conf
  echo -e "\nvm.$1=$2\n" >>$sysctl_conf
  sysctl vm.$1=$2
}

# 配置 ZRAM https://segmentfault.com/a/1190000041578292
# https://www.reddit.com/r/Fedora/comments/mzun99/new_zram_tuning_benchmarks/

set page-cluster 0
set extfrag_threshold 0
set swappiness 200
set vfs_cache_pressure 200
set dirty_ratio 2
set dirty_background_ratio 1

sed -i '/^[[:space:]]*$/d' $sysctl_conf

sysctl -p
systemctl enable --now zram-config
systemctl restart zram-config

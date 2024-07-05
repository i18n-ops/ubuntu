#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

sysctl_conf=/etc/sysctl.conf

set() {
  sysctl $1=$2
  sed -i "/^$1/d" $sysctl_conf
  echo -e "\n$1=$2\n" >>$sysctl_conf
}

set vm.min_free_kbytes 2097152
sed -i '/^[[:space:]]*$/d' $sysctl_conf

sysctl -p

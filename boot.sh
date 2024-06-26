#!/usr/bin/env bash

set -ex

apt-get update

ensure() {
  for pkg in "$@"; do
    if ! command -v $pkg &>/dev/null; then
      apt-get install -y $pkg
    fi
  done
}

ensure curl git

cd ~

clone() {
  out=$(basename $1 .git)
  if [ ! -d "$out" ]; then
    git clone -b main --recursive --depth=1 $1 $out
  else
    cd $out
    git pull || git reset --hard origin/main
    cd ..
  fi
}

clone https://atomgit.com/i18n-ops/ubuntu.git

exec ubuntu/init.sh

#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

./upgrade.sh || true

journalctl --vacuum-size=50M
. env.sh

git -C docker pull || git -C docker reset --hard origin/main

keep() {
  for i in "$@"; do
    if [ -f "$i" ]; then
      touch $i
    fi
  done
}

keep ~/.config/git.conf

apt-get update
apt-get install -y sd

rsync -avu ops/ /

source ./gfw.sh
./zram.sh

cd docker/dev

[ $GFW ] &&
  mkdir -p ~/.cargo &&
  cp build/zh/os/root/.cargo/* ~/.cargo/

./sh/soft.sh

rsync -avu _/root/ /root
./sh/zinit.sh
rm -rf ~/.bashrc ~/.zshrc

grep -q '^\[include\]' ~/.gitconfig || rm ~/.gitconfig

rsync -avu _/ /
./sh/end.sh

cd $DIR
./chrony.sh
./docker.sh
[ $CN ] && ./cn.sh

set +x
echo '✅ ubuntu init done'

#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

./init.sh
$DIR/../supervisor/init.sh
ini=clash.ini

fp=/etc/supervisor/conf.d/$ini

cp $DIR/supervisor/$ini $fp

if ! command -v cargo &>/dev/null; then
  if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
  fi
fi

mise="$(which mise) env"

if ! command -v sd &>/dev/null; then
  cargo install sd
fi

sd -s "\$EXE" "bash -c \"eval \\\"\$($mise)\\\" && cd $DIR && exec $DIR/run.sh\"" $fp

if ! command -v killall &>/dev/null; then
  apt-get install -y psmisc
fi

killall -9 clash || true

supervisorctl update
sleep 3
supervisorctl status

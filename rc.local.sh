#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

rsync -avu rc.local/ /
chmod +x /etc/rc.local
systemctl daemon-reload

systemctl enable rc-local
systemctl start rc-local

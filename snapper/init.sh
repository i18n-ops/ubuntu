#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR

set -ex

if ! command -v python &>/dev/null; then
  echo "need install python3"
  exit 1
fi

apt-get install -y snapper
systemctl enable --now snapper-timeline.timer
systemctl enable --now snapper-cleanup.timer
umount -a || true
conf() {
  sed -i "s/$1=\"[[:digit:]]\+\"/$1=\"$2\"/" /etc/snapper/configs/$3
}

conf_file() {
  local name=${1//\//_}
  local dir=${2:-$1}
  rm -rf /$dir/.snapshots
  snapper -c $name create-config /$dir
  conf NUMBER_LIMIT 99 $name
  conf NUMBER_LIMIT_IMPORTANT 99 $name
  conf TIMELINE_LIMIT_HOURLY 32 $name
  conf TIMELINE_LIMIT_DAILY 24 $name
  conf TIMELINE_LIMIT_WEEKLY 12 $name
  conf TIMELINE_LIMIT_MONTHLY 6 $name
  conf TIMELINE_LIMIT_YEARLY 3 $name

  local bakdir=/bak/$1

  rm -rf /$dir/.snapshots
  if [ ! -d "$bakdir" ]; then
    btrfs subvolume create $bakdir
  fi
  mkdir -p /$dir/.snapshots

}

snapper_conf() {
  for i in "$@"; do
    if ! command -v $i &>/dev/null; then
      local name=${i//\//_}
      if [ ! -f "/etc/snapper/configs/$name" ]; then
        conf_file $i
      fi
    fi
  done
}

li="etc opt home root mnt mnt/data os"

snapper_conf $li

if [ ! -f "/etc/snapper/configs/disk" ]; then
  conf_file disk /
fi

./init.py / $li

systemctl daemon-reload
mount -a
./snapshot.sh

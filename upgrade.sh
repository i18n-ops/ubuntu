#!/usr/bin/env bash

set -ex

export DEBIAN_FRONTEND=noninteractive
# sed -i 's/Prompt=LTS/Prompt=normal/i' /etc/update-manager/release-upgrades
apt update -y
apt="apt-get --yes"

cat <<EOF | tee /etc/apt/apt.conf.d/local
Dpkg::Options {
   "--force-confdef";
   "--force-confold";
}
EOF

$apt upgrade
$apt dist-upgrade
$apt install ubuntu-release-upgrader-core -y

do-release-upgrade -d -f DistUpgradeViewNonInteractive || true

dpkg --configure -a
$apt install -f -y
apt-get autoremove -y
apt-get autoclean -y
apt clean -y

apt-get autoremove -y --purge

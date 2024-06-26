#!/usr/bin/env python

import sys

li = []

with open("/etc/fstab", "r") as fstab:
    for line in fstab:
        line = line.rstrip("\n")
        if not line.lstrip().startswith("#"):
            t = line.split()
            if len(t) > 1:
                if t[1].endswith("/.snapshots"):
                    continue
        li.append(line)

for i in sys.argv[1:]:
    if i == "/":
        fp = "bak/disk"
    else:
        fp = "bak/" + i
        i = "/" + i + "/"

    line = f"/dev/sda3 {i}.snapshots btrfs defaults,ssd,discard,noatime,compress=zstd:3,space_cache=v2,autodefrag,subvol={fp} 0 0"
    li.append(line)

with open("/etc/fstab", "w") as fstab:
    fstab.write("\n".join(li))

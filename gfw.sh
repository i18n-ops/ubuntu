#!/usr/bin/env bash

curl --connect-timeout 2 -m 4 -s https://t.co >/dev/null || export GFW=1

CURL="curl --connect-timeout 5 --max-time 10 --retry 99 --retry-delay 0"

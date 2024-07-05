#!/usr/bin/env bash

cd $(dirname $(realpath $BASH_SOURCE))

clone() {
  if [ ! -d "$1" ]; then
    GIT=$(dirname $(git remote -v | head -1 | awk '{print $2}'))
    git clone -b main --depth=1 $GIT/$1.git
  fi
}

clone docker

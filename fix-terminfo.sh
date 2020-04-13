#!/usr/bin/env bash

mkdir -p .terminfo/r # on remote
scp /usr/share/terminfo/r/rxvt-unicode-256color c30:.terminfo/r/ # on local

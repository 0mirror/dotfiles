#!/bin/sh

[[ $(ping -c 1 -q archlinux.org >&/dev/null; echo $?) == 0 ]] && checkupdates | wc -l | tail -n1 | awk '{ print ($1 != 0) ? $1 : "" }'

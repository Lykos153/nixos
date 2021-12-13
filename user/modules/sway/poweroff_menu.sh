#!/usr/bin/env bash
while [ "$select" != "NO" -a "$select" != "YES" ]; do
    select=$(echo -e 'NO\nYES' | bemenu --nb '#151515' --nf '#999999' --sb '#f00060' --sf '#000000' --fn '-*-*-medium-r-normal-*-*-*-*-*-*-100-*-*' -i -p "Poweroff?" -w)
    [ -z "$select" ] && exit 0
done
[ "$select" = "NO" ] && exit 0
poweroff

#!/usr/bin/env bash

#needs grimshot and libnotify

screenshot_dir="$HOME/Bilder/Screenshots"

action=${1:=screen}

mkdir -p "$screenshot_dir"
result="$(grimshot save "$action" "$screenshot_dir/$(date +'%Y-%m-%d-%H%M%S.png')")"
notify-send "$result"

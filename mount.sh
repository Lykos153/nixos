#!/usr/bin/env bash
machine_name="$1"
sudo nix run github:nix-community/disko -- "$(dirname "$0")/system/machines/$machine_name/disko.nix" -m mount

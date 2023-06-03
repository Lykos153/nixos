#!/usr/bin/env bash
# Inspired by https://github.com/mjlbach/nix-dotfiles/blob/master/home-manager/install.sh
SCRIPTPATH=$(dirname $(readlink -f $0))
mount_path="${1:-/mnt}"
sudo nix copy --to "$mount_path" "$SCRIPTPATH"'#homeConfigurations.'"$(id -un)"'.activationPackage' --no-check-sigs

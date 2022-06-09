#!/usr/bin/env bash
# Inspired by https://github.com/mjlbach/nix-dotfiles/blob/master/home-manager/install.sh
#nix-shell -p nixUnstable --command "nix build --experimental-features 'nix-command flakes' '.#homeConfigurations.nixos.activationPackage'"
SCRIPTPATH=$(dirname $(readlink -f $0))
nix build "$SCRIPTPATH"'#homeConfigurations.'"$(id -un)"'.activationPackage' &&
result/activate &&
rm result

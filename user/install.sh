#!/usr/bin/env bash
# Inspired by https://github.com/mjlbach/nix-dotfiles/blob/master/home-manager/install.sh
nix-shell -p nixUnstable --command "nix build --experimental-features 'nix-command flakes' '.#homeConfigurations.nixos.activationPackage'"
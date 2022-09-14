## Adding new machines
1. Create desired partition layout on new machine & mount
1. `mkdir system/machines/<machine-name>`
1. `nixos-generate-config --root <mountpoint> --dir system/machines/<machine-name>`
1. Copy over `default.nix` and `bootloader.nix` from approriate folder (eg. silvio-pc) and adapt
1. `nixos-install --root <mountpoint> --flake ./system#<machine-name>`

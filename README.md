## Adding new machines
1. Create desired partition layout on new machine & mount at `$mountpoint`
1. `mkdir system/machines/$machine_name`
1. `nixos-generate-config --root $mountpoint --dir system/machines/$machine_name`
1. Copy over `default.nix` and `bootloader.nix` from approriate folder (eg. silvio-pc) to `system/machines/$machine_name` and adapt
1. `nixos-install --root $mountpoint --flake ./system\#$machine_name`

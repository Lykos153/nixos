## Adding new machines
1. Partition & mount
1. `mkdir <machine-name>`
2. `nixos-generate-config --root <mountpoint> --dir <machine-name>`
3. Copy over `default.nix` and `bootloader.nix` from approriate folder and adapt
4. `cd` to `system`
5. `nixos-install --root <mountpoint> --flake .#<machine-name>`

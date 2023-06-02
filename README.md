## Adding new machines
1. `mkdir system/machines/$machine_name`
1. Create desired partition layout on new machine & mount at `system/machines/$machine_name/disko.nix`
1. `sudo nix run github:nix-community/disko -- ./system/machines/$machine_name/disko.nix -m create`
1. `sudo nix run github:nix-community/disko -- ./system/machines/$machine_name/disko.nix -m mount`
1. `nixos-generate-config --no-filesystems --dir ./system/machines/$machine_name`
1. `rm system/machines/$machine_name/configuration.nix`
1. Copy over `default.nix` and `bootloader.nix` from approriate folder (eg. silvio-pc) to `system/machines/$machine_name` and adapt
1. `sudo nixos-install --flake ./system\#$machine_name`

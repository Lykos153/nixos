{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  outputs = { self, nixpkgs }:
    let mkHost = name: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
            ./configuration.nix
            (./hardware.d + "/${name}")
        ];
    }; in
    {
        nixosConfigurations = builtins.mapAttrs (name: _: mkHost name) (builtins.readDir ./hardware.d);
    };
}
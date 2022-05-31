{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.sops-nix.url = github:Mic92/sops-nix;

  outputs = { self, nixpkgs }:
  let
    #machinedir = ./machines
    mkHost = name: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
          ./configuration.nix
          (./machines + "/${name}")
          { networking.hostName = name; }

          sops-nix.nixosModules.sops
      ];
    };
  in
  {
      nixosConfigurations = builtins.mapAttrs (name: _: mkHost name) (builtins.readDir ./machines);
  };
}

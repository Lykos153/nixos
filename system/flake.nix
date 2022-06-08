{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  outputs = { self, nixpkgs }:
  let
    #machinedir = ./machines
    mkHost = name: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
          ./configuration.nix
          (./machines + "/${name}")
          {
            networking.hostName = name;
            nix.registry.nixpkgs.flake = nixpkgs; # Pin flakes so search, shell etc. are faster. From https://ianthehenry.com/posts/how-to-learn-nix/more-flakes/
          }
      ];
    };
  in
  {
      nixosConfigurations = builtins.mapAttrs (name: _: mkHost name) (builtins.readDir ./machines);
  };
}

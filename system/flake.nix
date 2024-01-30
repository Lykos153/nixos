{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.nixpkgs-master.url = "github:nixos/nixpkgs/master";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.impermanence.url = "github:nix-community/impermanence";
  inputs.sops-nix.url = "github:Mic92/sops-nix";
  inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";

  outputs = {
    self,
    nixpkgs,
    nixpkgs-master,
    disko,
    impermanence,
    sops-nix,
  }: let
    #machinedir = ./machines
    lib = (import ./lib.nix) {inherit nixpkgs;};
    modules = [
      disko.nixosModules.disko
      impermanence.nixosModules.impermanence
      sops-nix.nixosModules.sops
    ];
  in {
    nixosConfigurations = lib.mkHosts {
      inherit modules;
      machinedir = ./machines;
    };
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}

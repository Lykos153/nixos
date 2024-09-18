{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager";
    # home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    booq.url = "github:lykos153/nixos";
    booq.inputs.nixpkgs.follows = "nixpkgs";
    booq.inputs.home-manager.follows = "home-manager";
  };

  outputs = {
    self,
    nixpkgs,
    booq,
    nur,
    ...
  } @ inputs: rec {
    nixosConfigurations = booq.lib.nixos.mkHosts {
      inherit (inputs) nixpkgs;
      nixosModules = builtins.attrValues booq.nixosModules;
      homeManagerModules = builtins.attrValues booq.homeManagerModules;
      machinedir = ./machines;
      userdir = ./users;
    };
    homeConfigurations = booq.lib.homeManager.mkConfigs {
      inherit nixosConfigurations;
      inherit (inputs) nixpkgs home-manager;
      modules = builtins.attrValues booq.homeManagerModules;
      userdir = ./users;
    };
  };
}

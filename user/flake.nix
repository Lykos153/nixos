# Inspired https://github.com/sherubthakur/dotfiles/tree/89dd7dc0359ee0c84520fa3143f1763c326fc4d6

{
    description = "Home manager flake";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        # nixpkgs-master.url = "github:nixos/nixpkgs/master";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        # nur.url = "github:nix-community/NUR";
    };
    outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
        # overlays = [ nur.overlay ];
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
        };
    in
    {
        homeConfigurations = {
            home = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [
                    ./home.nix
                    {
                        home = {
                            homeDirectory = "/home/leila";
                            username = "leila";
                            stateVersion = "22.05";
                        };
                    }
                ];
            };
        };
    };
}

# Inspired https://github.com/sherubthakur/dotfiles/tree/89dd7dc0359ee0c84520fa3143f1763c326fc4d6

{
    description = "Home manager flake";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        home-manager.url = "github:nix-community/home-manager";
        # nur.url = "github:nix-community/NUR";
    };
    outputs = { self, nur, ... }@inputs:
    # let
    #     overlays = [ nur.overlay ];
    # in
    {
        homeConfigurations = {
            home = inputs.home-manager.lib.homeManagerConfiguration {
                system = "x86_64-linux";
                homeDirectory = "/home/silvio";
                username = "silvio";
                stateVersion = "22.05";
                configuration = { config, lib, nixosConfig, pkgs, ... }@configInput: {
                    imports = [ ./home.nix ];
                };
            };
        };
    };
}

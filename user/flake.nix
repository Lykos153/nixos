# Inspired https://github.com/sherubthakur/dotfiles/tree/89dd7dc0359ee0c84520fa3143f1763c326fc4d6

{
    description = "Home manager flake";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        # nixpkgs-master.url = "github:nixos/nixpkgs/master";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        # nur.url = "github:nix-community/NUR";
        get-flake.url = "github:ursi/get-flake";
    };
    outputs = { self, nixpkgs, home-manager, get-flake, ... }@inputs:
    let
    #     overlays = [ nur.overlay ];
        systemFlake = get-flake ../system;
        system = "x86_64-linux";
        mkConfig = hostname: username: config:
            let
                userpath = (./users + "/${username}");
                hostpath = (userpath + "/${hostname}");
                userlist = if builtins.pathExists userpath then [userpath] else [];
                hostlist = if builtins.pathExists hostpath then [hostpath] else [];
                nixpkgsConfigPath = userpath + "/nixpkgs-config.nix";
                pkgs = import nixpkgs {
                    inherit system;
                    config = if builtins.pathExists nixpkgsConfigPath then import nixpkgsConfigPath else {};
                };
            in
            (
            # inputs.nixpkgs.lib.nameValuePair
            #     (name + "silvio-pc")
                {
                    "name" = username;
                    "value" = inputs.home-manager.lib.homeManagerConfiguration {
                        inherit pkgs;
                        modules = [
                            ./home.nix
                            {
                                home = {
                                    homeDirectory = config.home;
                                    username = username;
                                    stateVersion = "22.05";
                                };
                            }
                        ] ++ userlist ++ hostlist;
                    };
                }
        );
        # mkHost = hostname: config:
        # (

        # )
    in
    {
        homeConfigurations = inputs.nixpkgs.lib.mapAttrs' (mkConfig "silvio-pc") systemFlake.outputs.nixosConfigurations.silvio-pc.config.users.users;
    };
}

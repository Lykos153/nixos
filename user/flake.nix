# Inspired https://github.com/sherubthakur/dotfiles/tree/89dd7dc0359ee0c84520fa3143f1763c326fc4d6

{
    description = "Home manager flake";
    inputs = {
        system.url = "../system"; # this is not ideal. lock will change with every modification in the repo
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        # nixpkgs-master.url = "github:nixos/nixpkgs/master";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        # nur.url = "github:nix-community/NUR";
    };
    outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
    #     overlays = [ nur.overlay ];
        mkUserConfig = host: name: config: (
            # inputs.nixpkgs.lib.nameValuePair
            #     (name + "silvio-pc")
                let
                    system = "x86_64-linux";
                    userpath = (./users + "/${name}");
                in
                {
                    "name" = name + "@" + host;
                    "value" = inputs.home-manager.lib.homeManagerConfiguration {
                        pkgs = nixpkgs.legacyPackages.${system};
                        modules = [
                            ./home.nix
                            {
                                home = {
                                    homeDirectory = config.home;
                                    username = name;
                                    stateVersion = "22.05";
                                };
                            }
                        ] ++ (if builtins.pathExists userpath then [userpath] else []);
                    };
                }
        );
    in
    {
        homeConfigurations = inputs.nixpkgs.lib.mapAttrs' (mkUserConfig "silvio-pc") (inputs.system.outputs.nixosConfigurations.silvio-pc.config.users.users);
    };
}

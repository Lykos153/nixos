# Inspired https://github.com/sherubthakur/dotfiles/tree/89dd7dc0359ee0c84520fa3143f1763c326fc4d6

{
    description = "Home manager flake";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        # nixpkgs-master.url = "github:nixos/nixpkgs/master";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        sops-nix.url = "github:Mic92/sops-nix";
        mynur.url = "github:Lykos153/nur-packages";
        #mynur.inputs.nixpkgs.follows = "nixpkgs";
        get-flake.url = "github:ursi/get-flake";
        mum-rofi.url = "github:lykos153/mum-rofi";
    };
    outputs = {
          self
        , nixpkgs
        , home-manager
        , get-flake
        , nur
        , mynur
        , mum-rofi
        , sops-nix
    }@inputs:
    let
        overlays = [ nur.overlay mynur.overlay];
        systemFlake = get-flake ../system;
        system = "x86_64-linux";
        booq = {
            options.booq.gui.enable = inputs.nixpkgs.lib.mkEnableOption "gui";
            options.booq.gui.sway.enable = inputs.nixpkgs.lib.mkEnableOption "sway";
            options.booq.gui.xorg.enable = inputs.nixpkgs.lib.mkEnableOption "xorg";
            options.booq.gui.xmonad.enable = inputs.nixpkgs.lib.mkEnableOption "xmonad";
            options.booq.gui.i3.enable = inputs.nixpkgs.lib.mkEnableOption "i3";
        };
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
                    overlays = overlays;
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
                            sops-nix.homeManagerModule
                            booq
                            ./home.nix
                            {
                                home = {
                                    homeDirectory = config.home;
                                    username = username;
                                    stateVersion = "22.05";
                                };
                            }
                            {
                                # TODO: There needs to be a better way. How can I use this from any other file in the repo?
                                home.packages = [
                                    mum-rofi.outputs.defaultPackage.${system}
                                ];
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
        inherit booq;
    };
}

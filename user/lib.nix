{home-manager,nixpkgs}: rec {
  mkConfig = {
    overlays,
    system,
    extraModules,
  }: hostname: username: config: let
    userpath = ./users + "/${username}";
    hostpath = userpath + "/${hostname}";
    userlist =
      if builtins.pathExists userpath
      then [userpath]
      else [];
    hostlist =
      if builtins.pathExists hostpath
      then [hostpath]
      else [];
    nixpkgsConfigPath = userpath + "/nixpkgs-config.nix";
    pkgs = import nixpkgs {
      inherit system;
      config =
        if builtins.pathExists nixpkgsConfigPath
        then import nixpkgsConfigPath
        else {};
      overlays = overlays;
    };
  in {
    "name" = username;
    "value" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules =
        [
          ./home.nix
          {
            home = {
              homeDirectory = config.home;
              username = username;
              stateVersion = "22.05";
            };
            booq = {
              nix-index = {
                enable = true;
                nixpkgs-path = "${nixpkgs}";
              };
            };
          }
          {
            home.sessionVariables.NIX_PATH = "nixpkgs=${nixpkgs}";
            # workaround because the above doesnt seem to work in xorg https://github.com/nix-community/home-manager/issues/1011#issuecomment-1365065753
            programs.zsh.initExtra = ''
              export NIX_PATH="nixpkgs=${nixpkgs}"
            '';
          }
        ]
        ++ extraModules
        ++ userlist
        ++ hostlist;
    };
  };
  mkConfigs = {
    nixosConfigurations,
    modules,
    overlays,
    system,
  }:
    nixpkgs.lib.mapAttrs' (mkConfig {
      inherit overlays home-manager system;
      extraModules = modules;
    } "silvio-pc")
    nixosConfigurations.silvio-pc.config.users.users;
}

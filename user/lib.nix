{
  home-manager,
  nixpkgs,
}: rec {
  mkModules = {
    username,
    hostname,
    extraModules ? {},
  }: let
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
  in ([
      ./home.nix
      {
        home = {
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
    ++ hostlist);

  mkConfig = {
    hostConfig,
    userConfig,
    overlays ? [],
    extraModules ? [],
  }: let
    username = userConfig.name;
    hostname = hostConfig.config.system.name;
  in
    home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs rec {
        system = hostConfig.pkgs.stdenv.hostPlatform.system;
        inherit overlays;
      };
      modules = mkModules {
        inherit username hostname;
        extraModules =
          extraModules
          ++ [
            {
              home = {
                homeDirectory = userConfig.home;
                username = username;
              };
            }
          ];
      };
    };

  mkConfigs = {
    nixosConfigurations,
    modules ? [],
    overlays ? [],
  }: let
    f = acc: hostname: hostConfig: let
      users = nixpkgs.lib.attrsets.filterAttrs (_: v: v.isNormalUser) hostConfig.config.users.users;
    in
      acc
      // nixpkgs.lib.mapAttrs' (user: userConfig: {
        name = "${user}@${hostname}";
        value = mkConfig {
          inherit hostConfig userConfig overlays;
          extraModules = modules;
        };
      })
      users;
  in
    nixpkgs.lib.attrsets.foldlAttrs f {} nixosConfigurations;
}

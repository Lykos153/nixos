{lib}: let
  commonName = "_common";
in rec {
  mkModules = {
    nixpkgs,
    username,
    hostname,
    userdir,
    modules ? [],
  }: let
    userpath = "${userdir}/${username}";
    hostpath = "${userpath}/${hostname}";

    usermodules =
      if builtins.pathExists userpath
      then [userpath]
      else [];
    hostmodules =
      if builtins.pathExists hostpath
      then [hostpath]
      else [];
    commonpath = "${userdir}/${commonName}";
    commonmodules =
      if builtins.pathExists commonpath
      then [commonpath]
      else [];
  in ([
      {
        home.sessionVariables.NIX_PATH = "nixpkgs=${nixpkgs}";
        # workaround because the above doesnt seem to work in xorg https://github.com/nix-community/home-manager/issues/1011#issuecomment-1365065753
        programs.zsh.initContent = ''
          export NIX_PATH="nixpkgs=${nixpkgs}"
        '';
      }
    ]
    ++ modules
    ++ usermodules
    ++ hostmodules
    ++ commonmodules);

  mkConfig = {
    nixpkgs,
    home-manager,
    hostConfig,
    userConfig,
    userdir,
    overlays ? [],
    modules ? [],
  }: let
    username = userConfig.name;
    hostname = hostConfig.config.system.name;
  in
    home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = hostConfig.pkgs.stdenv.hostPlatform.system;
        inherit overlays;
      };
      modules = mkModules {
        inherit nixpkgs username hostname userdir;
        modules =
          modules
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
    nixpkgs,
    home-manager,
    nixosConfigurations,
    userdir,
    modules ? [],
    overlays ? [],
  }: let
    f = acc: hostname: hostConfig: let
      users = lib.attrsets.filterAttrs (_: v: v.isNormalUser) hostConfig.config.users.users;
    in
      acc
      // lib.mapAttrs' (user: userConfig: {
        name = "${user}@${hostname}";
        value = mkConfig {
          inherit nixpkgs home-manager hostConfig userConfig userdir modules overlays;
        };
      })
      users;
  in
    lib.attrsets.foldlAttrs f {} nixosConfigurations;
}

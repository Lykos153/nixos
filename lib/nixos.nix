let
  commonName = "_common";
  lib = import ./.;
  dirWithoutCommon = nixpkgs: dirname:
    nixpkgs.lib.filterAttrs (name: type: name != commonName && type == "directory")
    (builtins.readDir dirname);
in rec {
  mkHost = {
    nixpkgs,
    hostname,
    nixosModules,
    homeManagerModules,
    machinedir,
    userdir,
    flakeInputs ? [],
  }: let
    commonpath = machinedir + "/${commonName}";
    commonmodules =
      if builtins.pathExists commonpath
      then [commonpath]
      else [];
  in
    nixpkgs.lib.nixosSystem {
      modules =
        nixosModules
        ++ commonmodules
        ++ [
          (machinedir + "/${hostname}")
          {
            networking.hostName = hostname;
            # Pin flakes so search, shell etc. are faster. From https://ianthehenry.com/posts/how-to-learn-nix/more-flakes/
            nix.registry = nixpkgs.lib.mapAttrs (_: flake: {inherit flake;}) (nixpkgs.lib.filterAttrs (_: v: (v._type or null) == "flake") flakeInputs);
          }
          {
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.sharedModules = homeManagerModules;
            home-manager.users = builtins.mapAttrs (
              username: _: {
                imports = lib.homeManager.mkModules {
                  inherit nixpkgs hostname userdir username;
                };
              }
            ) (dirWithoutCommon nixpkgs userdir);
          }
        ];
    };
  mkHosts = {
    nixpkgs,
    machinedir,
    userdir,
    nixosModules,
    homeManagerModules,
    flakeInputs ? [],
  }:
    builtins.mapAttrs (name: _:
      mkHost {
        hostname = name;
        inherit nixpkgs machinedir userdir nixosModules homeManagerModules flakeInputs;
      }) (dirWithoutCommon nixpkgs machinedir);
}

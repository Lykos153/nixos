{lib}: let
  booq-lib = import ./. {inherit lib;};
  commonName = "_common";
  dirWithoutCommon = dirname:
    lib.filterAttrs (name: type: name != commonName && type == "directory")
    (builtins.readDir dirname);
  commonmodules = dirs:
    lib.pipe dirs [
      (map (d: d + "/${commonName}"))
      (lib.filter builtins.pathExists)
    ];
in rec {
  mkHost = {
    nixpkgs,
    hostname,
    nixosModules,
    homeManagerModules,
    machinedir,
    userdirs,
    flakeInputs ? {},
    hmUseGlobalPkgs ? false,
  }:
    nixpkgs.lib.nixosSystem {
      specialArgs = {inputs = flakeInputs;};
      modules =
        nixosModules
        ++ [
          (machinedir + "/${hostname}")
          {
            networking.hostName = hostname;
            # Pin flakes so search, shell etc. are faster. From https://ianthehenry.com/posts/how-to-learn-nix/more-flakes/
            nix.registry = lib.pipe flakeInputs [
              (lib.filterAttrs (_: v: (v._type or null) == "flake"))
              (lib.mapAttrs (_: flake: {inherit flake;}))
            ];
          }
          {
            home-manager.useGlobalPkgs = hmUseGlobalPkgs;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.sharedModules = homeManagerModules;
            home-manager.extraSpecialArgs = {inputs = flakeInputs;};
            home-manager.users = lib.foldl (acc: userdir:
              lib.attrsets.unionOfDisjoint acc (builtins.mapAttrs (
                username: _: {
                  imports = booq-lib.homeManager.mkModules {
                    inherit nixpkgs hostname userdir username;
                    modules = commonmodules userdirs;
                  };
                }
              ) (dirWithoutCommon userdir))) {}
            userdirs;
          }
        ];
    };
  mkHosts = {
    nixpkgs,
    machinedirs,
    userdirs,
    nixosModules,
    homeManagerModules,
    flakeInputs ? {},
  }:
    lib.foldl (acc: machinedir:
      lib.attrsets.unionOfDisjoint acc (builtins.mapAttrs (name: _:
        mkHost {
          hostname = name;
          nixosModules = nixosModules ++ (commonmodules machinedirs);
          inherit nixpkgs machinedir userdirs homeManagerModules flakeInputs;
        }) (dirWithoutCommon machinedir))) {}
    machinedirs;
}

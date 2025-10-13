{
  self,
  inputs,
  lib,
  config,
  ...
}: let
  cfg = config.flake.machines;
  modulesOption = lib.mkOption {
    type = with lib.types; listOf raw;
    default = [];
  };
in {
  options.flake.machines.commonModules = modulesOption;
  options.flake.machines.hosts = lib.mkOption {
    type = with lib.types;
      attrsOf (
        submodule {
          freeformType = attrsOf anything;
          options = {
            modules = modulesOption;
          };
        }
      );
    default = {};
  };
  config.flake.machines = {
    commonModules =
      (builtins.attrValues self.nixosModules)
      ++ (let
        commonpath = ./. + "/_common";
      in
        lib.optional (builtins.pathExists commonpath) commonpath);
    hosts =
      lib.mapAttrs (
        hostname: _: {
          modules = [(./. + "/${hostname}")];
        }
      ) (
        lib.filterAttrs (name: type: !(lib.hasPrefix "_" name) && type == "directory")
        (builtins.readDir ./.)
      );
  };
  config.flake.nixosConfigurations = let
    mkMachine = hostname: hostConfig:
      inputs.nixpkgs.lib.nixosSystem (hostConfig
        // {
          modules =
            hostConfig.modules
            ++ cfg.commonModules
            ++ [
              {
                networking.hostName = hostname;
                # Pin flakes so search, shell etc. are faster. From https://ianthehenry.com/posts/how-to-learn-nix/more-flakes/
                nix.registry = lib.mapAttrs (_: flake: {inherit flake;}) (lib.filterAttrs (_: v: (v._type or null) == "flake") inputs);
              }
              {
                home-manager.useGlobalPkgs = false;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "bak";
                home-manager.users =
                  lib.mapAttrs (
                    _: v: {
                      imports =
                        config.flake.users.commonModules
                        ++ v.modules
                        ++ (v.hostSpecificModules.${hostname} or []);
                    }
                  )
                  config.flake.users.users;
              }
            ];
        });
  in
    lib.mapAttrs mkMachine cfg.hosts;
}

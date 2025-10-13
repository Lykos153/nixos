{
  self,
  inputs,
  lib,
  config,
  ...
}: let
  cfg = config.flake.users;
  modulesOption = lib.mkOption {
    type = with lib.types; listOf raw;
    default = [];
  };
in {
  options.flake.users.commonModules = modulesOption;
  options.flake.users.users = lib.mkOption {
    type = with lib.types;
      attrsOf (
        submodule {
          freeformType = attrsOf anything;
          options = {
            modules = modulesOption;
            hostSpecificModules = lib.mkOption {
              type = attrsOf (listOf raw);
              default = {};
            };
          };
        }
      );
    default = {};
  };
  config.flake.users = {
    commonModules =
      [
        {
          home.sessionVariables.NIX_PATH = "nixpkgs=${inputs.nixpkgs}";
          # workaround because the above doesnt seem to work in xorg https://github.com/nix-community/home-manager/issues/1011#issuecomment-1365065753
          programs.zsh.initContent = ''
            export NIX_PATH="nixpkgs=${inputs.nixpkgs}"
          '';
        }
      ]
      ++ (builtins.attrValues self.homeManagerModules)
      ++ (let
        commonpath = ./. + "/_common";
      in
        lib.optional (builtins.pathExists commonpath) commonpath);
    users =
      lib.mapAttrs (
        username: _: let
          userpath = ./. + "/${username}";
        in {
          modules = [userpath];
          hostSpecificModules =
            lib.mapAttrs (
              hostname: _: let
                hostpath = userpath + "/${hostname}";
              in
                lib.optional (builtins.pathExists hostpath) hostpath
            )
            config.flake.machines;
        }
      ) (
        lib.filterAttrs (
          name: type: (!lib.hasPrefix "_" name) && type == "directory"
        )
        (builtins.readDir ./.)
      );
  };
  config.flake.homeConfigurations = let
    mkUserConfig = {
      username,
      hostname,
      homeDirectory,
      pkgs ? null,
    }:
      inputs.home-manager.lib.homeManagerConfiguration (
        (builtins.removeAttrs cfg.users.${username} ["hostSpecificModules"])
        // (lib.optionalAttrs pkgs != null {inherit pkgs;})
        // {
          modules =
            cfg.commonModules
            ++ cfg.users.${username}.modules
            ++ (cfg.users.${username}.hostSpecificModules.${hostname} or [])
            ++ [
              {
                home = {
                  inherit username homeDirectory;
                };
              }
            ];
        }
      );
    mkUserConfigs = let
      f = acc: hostname: hostConfig: let
        users = lib.pipe hostConfig.config.users.users [
          (lib.filterAttrs (_: v: v.isNormalUser))
          (lib.mapAttrs (_: v: v.home))
          (builtins.intersectAttrs (cfg.users))
        ];
      in
        acc
        // lib.mapAttrs' (username: homeDirectory: {
          name = "${username}@${hostname}";
          value = mkUserConfig {
            inherit username hostname homeDirectory;
            pkgs = import inputs.nixpkgs {
              system = hostConfig.pkgs.stdenv.hostPlatform.system;
            };
          };
        })
        users;
    in
      lib.foldlAttrs f {} self.nixosConfigurations;
  in
    mkUserConfigs;
}

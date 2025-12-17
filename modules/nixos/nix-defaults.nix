{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.booq.nix-defaults;
in {
  options.booq.nix-defaults = {
    enable = lib.mkEnableOption "";
    auto-gc = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    gc.percentFree = lib.mkOption {
      type = lib.types.ints.between 0 100;
      default = 5;
    };
  };

  config = lib.mkIf cfg.enable {
    nix = {
      package = lib.mkOverride 999 pkgs.nixVersions.stable;
      settings.auto-optimise-store = true;

      gc = lib.mkIf cfg.auto-gc {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 90d";
      };

      extraOptions = ''
        experimental-features = nix-command flakes
        min-free = ${toString (1024 * 1024 * 1024)}
        max-free = ${toString (5 * 1024 * 1024 * 1024)}
      '';

      daemonCPUSchedPolicy = "idle";
      daemonIOSchedClass = "idle";
      daemonIOSchedPriority = 7;
    };

    systemd.services.nix-gc.script = lib.mkForce ''
      if [[ "$(LANG=C ${pkgs.coreutils}/bin/df /nix/store | ${pkgs.jc}/bin/jc --df | ${pkgs.jq}/bin/jq '.[0].use_percent')" -lt ${toString (100 - cfg.gc.percentFree)} ]]; then
        echo "Skipping garbage collection. Threshold of ${toString cfg.gc.percentFree} not reached."
        exit
      fi
      exec ${config.nix.package.out}/bin/nix-collect-garbage ${config.nix.gc.options}
    '';
  };
}

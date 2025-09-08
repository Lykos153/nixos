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
  };

  config.nix = lib.mkIf cfg.enable {
    package = pkgs.nixVersions.stable;
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
}

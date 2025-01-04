{
  lib,
  config,
  ...
}: let
  cfg = config.booq.ccache;
in {
  options.booq.ccache.enable = lib.mkEnableOption "ccache";
  config = lib.mkIf cfg.enable {
    programs.ccache.enable = true;
    programs.ccache.packageNames = ["linux_bcachefs"];
    nix.settings.extra-sandbox-paths = [config.programs.ccache.cacheDir];
    environment.persistence."${config.booq.impermanence.persistRoot}".directories = [config.programs.ccache.cacheDir];
  };
}

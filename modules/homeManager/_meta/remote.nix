{
  lib,
  config,
  ...
}: let
  cfg = config.booq.remote;
in {
  options.booq.remote = {
    enable = lib.mkEnableOption ''
      Enable all modules necessary on workstations.
    '';
  };
  config.booq = lib.mkIf cfg.enable {
    minimal.enable = true;
    # helix.enableLanguageServers = true;
    ranger.enable = true;
    zellij.enable = true;
  };
}

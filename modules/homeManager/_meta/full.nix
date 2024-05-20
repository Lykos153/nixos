{
  lib,
  config,
  ...
}: let
  cfg = config.booq.full;
in {
  options.booq.full = {
    enable = lib.mkEnableOption ''
      Enable all modules.
    '';
  };
  config.booq = lib.mkIf cfg.enable {
    minimal.enable = true;
    workstation.enable = true;
    devops.enable = true;
  };
}

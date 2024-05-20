{
  lib,
  config,
  ...
}: let
  cfg = config.booq.devops;
in {
  options.booq.devops = {
    enable = lib.mkEnableOption ''
      Enable all modules necessary on devopss.
    '';
  };
  config.booq = lib.mkIf cfg.enable {
    workstation.enable = true;
    k8sAdmin.enable = true;
  };
}

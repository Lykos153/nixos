{
  lib,
  config,
  ...
}: let
  cfg = config.booq.full;
in {
  options.booq.full = {
    enable = lib.mkEnableOption ''
      Enable all modules except
        * securityKeys
        * gaming
        * sops
        * impermanence
    '';
  };
  config.booq = lib.mkIf cfg.enable {
    minimal.enable = true;
    workstation.enable = true;

    adb.enable = true;
    ausweisapp.enable = true;
    dotool.enable = true;
    podman.enable = true;
    virtualisation.enable = true;
  };
}

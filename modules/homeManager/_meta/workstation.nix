{
  lib,
  config,
  ...
}: let
  cfg = config.booq.workstation;
in {
  options.booq.workstation = {
    enable = lib.mkEnableOption ''
      Enable all modules necessary on workstations.
    '';
  };
  config.booq = lib.mkIf cfg.enable {
    minimal.enable = true;
    languageServers = true;
    timewarrior.enable = true;
    comma.enable = true;
    fonts.enable = true;
    pass.enable = true;
    ranger.enable = true;
    ssh.enable = true;
    taskwarrior.enable = true;
    zellij.enable = true;

    firefox.enable = true;
    thunderbird.enable = true;
  };
}

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
    audio.enable = true;
    gui.enable = true;
    printing.enable = true;
    keyd.enable = true;
  };
}

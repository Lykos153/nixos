{
  config,
  lib,
  ...
}: let
  cfg = config.booq.zellij;
in {
  options.booq.zellij = {
    enable = lib.mkEnableOption "zellij";
  };
  config = lib.mkIf cfg.enable {
    programs.zellij.enable = true;

    programs.nushell.extraConfig = ''
      if ( ((tty) | str starts-with "/dev/tty") and ((tty) != "/dev/tty1") ) {
        zellij
      }
    '';
  };
}

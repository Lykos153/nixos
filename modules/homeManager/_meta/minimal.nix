{
  lib,
  config,
  ...
}: let
  cfg = config.booq.minimal;
in {
  options.booq.minimal = {
    enable = lib.mkEnableOption ''
      Enable the minimal set of modules needed in most cases.
    '';
  };
  config.booq = lib.mkIf cfg.enable {
    git.enable = true;
    gpg.enable = true;
    helix.enable = true;
    mynix.enable = true;
    nushell.enable = true;
    zsh.enable = true;
  };
}

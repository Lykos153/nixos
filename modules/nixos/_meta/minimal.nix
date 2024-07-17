{
  lib,
  config,
  ...
}: let
  cfg = config.booq.minimal;
in {
  options.booq.minimal = {
    enable = lib.mkEnableOption ''
      Enable the minimal set of modules needed on most systems.
    '';
  };
  config.booq = lib.mkIf cfg.enable {
    locale.enable = true;
    networking.enable = true;
    nix-defaults.enable = true;
    smartd.enable = true;
    zsh.enable = true;
  };
}

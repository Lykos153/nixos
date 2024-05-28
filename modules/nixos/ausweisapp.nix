{
  config,
  lib,
  ...
}: let
  cfg = config.booq.ausweisapp;
in {
  options.booq.ausweisapp = {
    enable = lib.mkEnableOption "ausweisapp";
  };
  config = lib.mkIf cfg.enable {
    programs.ausweisapp = {
      enable = true;
      openFirewall = true;
    };
  };
}

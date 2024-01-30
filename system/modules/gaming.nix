{
  lib,
  config,
  ...
}: {
  options.booq.gaming.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };
  config = lib.mkIf config.booq.gaming.enable {
    booq.lib.allowUnfreePackages = [
      "steam(-.*)?"
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}

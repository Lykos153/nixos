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
    nixpkgs.allowUnfreePackages = [
      "steam"
      "steam-run"
      "steam-original"
      "steam-runtime"
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}

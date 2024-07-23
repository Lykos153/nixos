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

    # shared steam library
    # either with bindfs https://discourse.nixos.org/t/how-to-setup-s3fs-mount/6283/5

    # or (preferred for performance reasons) with ACL https://www.reddit.com/r/linux_gaming/comments/5d25oe/comment/da1tdv7/
  };
  # TODO service to set this on shared gaming directory
  # sudo setfacl -m default:other:rwX -R /opt/steam
  # sudo setfacl -m other:rwX -R /opt/steam
}

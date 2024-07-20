{
  lib,
  config,
  ...
}: let
  cfg = config.booq.install-image;
in {
  options.booq.install-image = {
    enable = lib.mkEnableOption ''
      Enable modules needed in an install image
    '';
  };
  config = lib.mkIf cfg.enable {
    # TODO: make this an actual module
    booq.minimal.enable = true;
    booq.networking.enable = lib.mkForce false;
    booq.users.enable = true;

    services.openssh.enable = true;
    security.sudo.wheelNeedsPassword = false;

    # lvm options
    boot.initrd.kernelModules = [
      "dm-snapshot" # when you are using snapshots
      "dm-raid" # e.g. when you are configuring raid1 via: `lvconvert -m1 /dev/pool/home`
      "dm-cache-default" # when using volumes set up with lvmcache
    ];

    services.lvm.boot.thin.enable = true; # when using thin provisioning or caching
  };
}

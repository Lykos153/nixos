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

    # Filesystems from https://github.com/NixOS/nixpkgs/blob/1a88164cc03ff2b7f3e79c042bee932bce7f036d/nixos/modules/profiles/base.nix#L52C2-L53C67
    # minus ZFS plus NTFS and bcachefs
    boot.supportedFilesystems = lib.mkForce ["btrfs" "cifs" "f2fs" "jfs" "ntfs" "reiserfs" "vfat" "xfs" "ntfs" "bcachefs"];

    # lvm options
    boot.initrd.kernelModules = [
      "dm-snapshot" # when you are using snapshots
      "dm-raid" # e.g. when you are configuring raid1 via: `lvconvert -m1 /dev/pool/home`
      "dm-cache-default" # when using volumes set up with lvmcache
    ];

    services.lvm.boot.thin.enable = true; # when using thin provisioning or caching
  };
}

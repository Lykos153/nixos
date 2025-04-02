{config, ...}: {
  booq.impermanence.enable = true;

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "size=95%"
      "defaults"
      "mode=755"
    ];
  };

  boot.initrd.luks.devices."luks-57dbe0ea-0119-40f4-9240-25f4a8148371".device = "/dev/disk/by-uuid/57dbe0ea-0119-40f4-9240-25f4a8148371";

  fileSystems."${config.booq.impermanence.persistRoot}" = {
    device = "/dev/disk/by-uuid/7e9ba1e1-621b-487e-a41d-f21bfc3f0d61";
    fsType = "ext4";
    neededForBoot = true;
  };

  fileSystems."/nix" = {
    device = "${config.booq.impermanence.persistRoot}/nix";
    options = ["bind" "noatime"];
  };

  fileSystems."/home" = {
    device = "${config.booq.impermanence.persistRoot}/home";
    options = ["bind"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/827D-5DFC";
    fsType = "vfat";
  };
}

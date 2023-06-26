{
  fileSystems."/btrfs" =
    { device = "/dev/mapper/arch-root";
      fsType = "btrfs";
      options = [ "subvol=/" "ro" ];
    };

  boot.initrd.luks.devices."arch-root".device = "/dev/disk/by-uuid/b474463d-7d93-4abf-95cd-35db2f9a6490";
  boot.initrd.luks.devices."arch-root2".device = "/dev/disk/by-uuid/efae7e7f-5c77-4957-9a75-f2862e620d15";
  boot.initrd.luks.devices."arch-root3".device = "/dev/disk/by-uuid/d55b7110-02b2-47fd-9441-bf53c67eeccc";
}

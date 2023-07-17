{ lib, ... }:
{
  environment.etc.crypttab = {
    enable = true;
    text = ''
      arch-root /dev/disk/by-uuid/b474463d-7d93-4abf-95cd-35db2f9a6490 /persist/passwords/luks_old_btrfs luks,nofail
      arch-root2 dev/disk/by-uuid/efae7e7f-5c77-4957-9a75-f2862e620d15 /persist/passwords/luks_old_btrfs luks,nofail
      arch-root3 dev/disk/by-uuid/d55b7110-02b2-47fd-9441-bf53c67eeccc /persist/passwords/luks_old_btrfs luks,nofail
    '';
  };
  fileSystems."/btrfs" =
    { device = "/dev/mapper/arch-root";
      fsType = "btrfs";
      options = [ "subvol=/" "ro" "x-systemd.automount" ] ++ lib.lists.forEach [ "arch-root2" "arch-root3" ] (dev: "x-systemd.requires-mounts-for=/dev/mapper/${dev}" );
    };
}

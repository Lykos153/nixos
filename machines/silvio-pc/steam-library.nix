{
  lib,
  config,
  ...
}: {
  fileSystems."/home/gamer/.local/share/Steam" = {
    device = "/dev/disk/by-partlabel/disk-nvme-eui-steam";
    fsType = "ext4";
    # options = ["casefold"];
    # TODO: maybe share steam library between users using ACLs https://askubuntu.com/a/796811
  };
}

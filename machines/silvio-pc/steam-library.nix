{
  lib,
  config,
  ...
}: {
  fileSystems."/home/gamer/.local/share/steam-ext4" = {
    device = "/home/gamer/.local/share/steam-ext4.img";
    fsType = "ext4";
    options = ["loop"];
    # TODO: maybe share steam library between users using ACLs https://askubuntu.com/a/796811
  };
}

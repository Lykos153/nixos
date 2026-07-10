{
  config,
  lib,
  ...
}: let
  steamUsers = ["silvio" "gamer" "mine" "leila"];
  idmapOption = uid: gid:
    "X-mount.idmap=" + lib.concatStringsSep "\\040" [
      "u:0:${toString uid}:1"
      "g:0:${toString gid}:1"
    ];
in {
  fileSystems = lib.foldl' (acc: username:
    acc
    // {
      "/home/${username}/.local/share/Steam" = let
        user = config.users.users.${username};
        group = config.users.groups.${user.group};
      in {
        device = "/bcachefs/Steam";
        fsType = "none";
        options = [
          "bind"
          (idmapOption user.uid group.gid)
        ];
      };
    }) {}
  steamUsers;
}


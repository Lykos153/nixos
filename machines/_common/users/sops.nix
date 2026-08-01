{
  lib,
  config,
  ...
}: let
  inherit (config.booq.users) filterUsers;
  users = [
    "silvio"
    "sa"
    "mine"
    "leila"
    "gamer"
  ];
  finalUsers =
    ["root"]
    ++ (
      if filterUsers == null
      then users
      else lib.intersectLists filterUsers users
    );
in
  lib.mkIf config.booq.sops.enable {
    users.users = lib.listToAttrs (lib.map (user:
      lib.nameValuePair user {
        hashedPasswordFile = config.sops.secrets."user-passwords/${user}".path;
      })
    finalUsers);

    sops.secrets = lib.listToAttrs (lib.map (user:
      lib.nameValuePair "user-passwords/${user}" {
        name = user;
        key = user;
        sopsFile = ./secrets.yaml;
        neededForUsers = true;
      })
    finalUsers);
  }

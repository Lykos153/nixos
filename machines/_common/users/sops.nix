{
  lib,
  config,
  ...
}: let
  genUserPasswd = user: {
  };
  users = lib.intersectLists config.booq.users.filterUsers [
    "silvio"
    "root"
    "sa"
    "mine"
    "leila"
    "gamer"
  ];
in
  lib.mkIf config.booq.sops.enable {
    users.users = lib.listToAttrs (lib.map (user:
      lib.nameValuePair user {
        hashedPasswordFile = config.sops.secrets."user-passwords/${user}".path;
      })
    users);

    sops.secrets = lib.listToAttrs (lib.map (user:
      lib.nameValuePair "user-passwords/${user}" {
        name = user;
        key = user;
        sopsFile = ./secrets.yaml;
        neededForUsers = true;
      })
    users);
  }

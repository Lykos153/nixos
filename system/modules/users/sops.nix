{
  lib,
  config,
  ...
}: let
  genUserPasswd = user: {
    users.users.${user}.hashedPasswordFile = config.sops.secrets."user-passwords/${user}".path;

    sops.secrets."user-passwords/${user}" = {
      name = "${user}";
      key = "${user}";
      sopsFile = ./secrets.yaml;
      neededForUsers = true;
    };
  };
  users = [
    "silvio"
    "root"
    "sa"
    "mine"
  ];
in
  lib.mkIf config.booq.sops.enable (
    builtins.foldl' lib.recursiveUpdate {} (
      builtins.foldl' (acc: user: acc ++ [(genUserPasswd user)]) [] users
    )
  )

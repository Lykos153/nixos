{ lib, config, ... }:
let
  a = 0;
in
lib.mkIf config.booq.sops.enable {
  users.users.root.passwordFile = config.sops.secrets."user-passwords/root".path;
  users.users.silvio.passwordFile = config.sops.secrets."user-passwords/silvio".path;

  sops.secrets."user-passwords/silvio" = {
    name = "silvio";
    key = "silvio";
    sopsFile = ./secrets.yaml;
    neededForUsers = true;
  };
  sops.secrets."user-passwords/root" = {
    name = "root";
    key = "root";
    sopsFile = ./secrets.yaml;
    neededForUsers = true;
  };
}

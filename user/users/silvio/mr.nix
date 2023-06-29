{ config, home, ... }:
{
  sops.secrets.mrconfig = {
    sopsFile = ./secrets/mrconfig;
    format = "binary";
  };
  # TODO: Make this so the path isnt hard coded. maybe a module that spawns a service. then i can use it generically for all users. why isnt this built into sops-nix?
  home.file.".mrconfig".source = config.lib.file.mkOutOfStoreSymlink "/run/user/1000/secrets/mrconfig";
}

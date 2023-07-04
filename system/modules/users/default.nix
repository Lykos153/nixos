{ pkgs, config, ... }:
{
  users.users.silvio = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  users.users.sa = {
    uid = 1003;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  users.users.mine = {
    uid = 1001;
    isNormalUser = true;
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  users.users.leila = {
    uid = 1002;
    isNormalUser = true;
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  users.users.root.shell = pkgs.zsh;
  # users.users.root.passwordFile = config.sops.secrets."user-passwords/root".path;
  users.users.root.passwordFile = "/run/secrets-for-users/root";

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

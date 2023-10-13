{ config, lib, pkgs, ... }: let
  opassDir = "${config.home.homeDirectory}/opsi-data/opsi-pass";
  aopassDir = "${config.home.homeDirectory}/opsi-data/aoterra_admin_passwords";
in
{
  programs.rofi.pass.stores = [ opassDir aopassDir ];
  programs.zsh = {
    shellAliases = {
      opass = "PASSWORD_STORE_DIR=${opassDir} pass";
      aopass = "PASSWORD_STORE_DIR=${aopassDir} pass";
    };
  };
}

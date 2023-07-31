{ config, lib, pkgs, ... }:
{
  programs.zsh = {
    shellAliases = {
      opass = "PASSWORD_STORE_DIR=$HOME/opsi-data/opsi-pass pass";
      aopass = "PASSWORD_STORE_DIR=$HOME/aoterra_admin_passwords pass";
    };
  };
}

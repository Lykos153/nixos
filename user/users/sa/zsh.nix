{ config, lib, pkgs, ... }:
{
  programs.zsh = {
    shellAliases = {
      opsipass = "PASSWORD_STORE_DIR=$HOME/cah/opsi-data/opsi-pass pass";
    };
  };
}

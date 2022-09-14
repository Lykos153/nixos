{ config, lib, nixosConfig, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    compression = true;
    forwardAgent = false;
    extraConfig = ''
      AddKeysToAgent yes
    '';
    includes = [ "local.d/*" ];
  };
  home.packages = with pkgs; [
    mosh
  ];
}

{ config, lib, pkgs, ... }:
{
  home.file.".local/bin".source = ./bin;
  home.file.".local/bin".recursive = true;
}
{ config, home, ... }:
{
  home.file.".mrconfig".source = ./mrconfig;
}

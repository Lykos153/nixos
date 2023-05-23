{ pkgs, ... }:
{
  home.packages = with pkgs; [ vdirsyncer khal ];
}

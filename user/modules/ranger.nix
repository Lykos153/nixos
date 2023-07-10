{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ranger
  ];

  xdg.configFile."ranger/rc.conf".text = ''
    mouse_enabled false
    alias git shell gitui
  '';
}

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ranger
  ];

  xdg.configFile."ranger/rc.conf".text = ''
    set mouse_enabled false
    alias git shell gitui
    map gg shell gitui
  '';
}

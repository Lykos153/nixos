{ config, lib, nixosConfig, pkgs, ... }:
lib.mkIf (config.booq.gui.enable && config.booq.gui.xorg.enable) {
  xsession.enable = true;

  home.packages = with pkgs; [
    arandr
    autorandr
    inputplug
  ];
  home.file.".xinitrc".source = ./xinitrc;

  # Start on tty1
  programs.zsh.initExtra = /* sh */ ''
    if [[ $(tty) = /dev/tty1 ]]; then
        unset __HM_SESS_VARS_SOURCED __NIXOS_SET_ENVIRONMENT_DONE # otherwise sessionVariables are not updated
        exec systemd-cat -t startx startx
    fi
  '';

  services.betterlockscreen = {
    enable = true;
    inactiveInterval = 30;
  };

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/davatorium/rofi/next/themes/arthur.rasi";
      sha256 = "sha256-2wlR+UURxmk9KvSYm/PmwNKDPC/GV0HcQEH7xDW53k0=";
    } + ""; #TODO: How to properly convert the set to a string or path?
  };

}

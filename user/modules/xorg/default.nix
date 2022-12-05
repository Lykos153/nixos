{ config, lib, nixosConfig, pkgs, ... }:
lib.mkIf (config.booq.gui.enable && config.booq.gui.xorg.enable) {
  xsession.enable = true;

  home.packages = with pkgs; [
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
}

{ config, lib, nixosConfig, pkgs, ... }:
lib.mkIf (config.booq.gui.enable && config.booq.gui.xmonad.enable) {
  booq.gui.xorg.enable = true;
  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = ./xmonad.hs;
  };

  home.packages = with pkgs; [
  ];

  xdg.configFile."xmobarrc".source = ./xmobarrc;
  systemd.user.services.xmobar = {
    Unit.PartOf = [ "hm-graphical-session.target" ];
    Install.WantedBy = [ "hm-graphical-session.target" ];

    Service = {
      Environment = [
        "DISPLAY=:0"
      ];
      ExecStart = ''
        ${pkgs.xmobar}/bin/xmobar ${config.xdg.configHome}/xmobarrc
      '';
      Restart = "on-failure";
    };
  };

}

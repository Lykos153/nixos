{
  services.xserver = {
    displayManager.lightdm = {
      enable = true;
      extraSeatDefaults = ''
        greeter-show-manual-login=true
        greeter-hide-users=false
      '';
    };
    desktopManager = {
      cinnamon.enable = true;
    };
    displayManager.defaultSession = "cinnamon";
  };
}

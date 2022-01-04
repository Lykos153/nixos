{config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
  ];

  services.logind.extraConfig = ''
    # wer baut bitte den Powerbutton an die Seite?!?!
    HandlePowerKey=ignore
  '';
}

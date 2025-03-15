# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./users
    ./vpn
  ];
  booq.networking.sopsFile = ./secrets.yaml;

  security.sudo.extraConfig = ''
    # to make <() work with sudo
    Defaults closefrom_override
    # impermanence results in sudo lectures after each reboot
    Defaults lecture = never
  '';

  boot.supportedFilesystems = ["ntfs" "bcachefs"];
  boot.initrd.systemd.enable = config.booq.lib.mkMyDefault true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  services.fstrim.enable = true;
  services.udisks2.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket"; # Enabling A2DP Sink https://nixos.wiki/wiki/Bluetooth
    };
  };
  services.blueman.enable = true;

  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.grub.memtest86.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

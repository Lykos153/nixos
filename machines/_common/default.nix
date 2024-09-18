# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: {
  nix = {
    settings.auto-optimise-store = true;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      min-free = ${toString (1024 * 1024 * 1024)}
      max-free = ${toString (5 * 1024 * 1024 * 1024)}
    '';

    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";

    settings.substituters = [
      "https://lykos153.cachix.org"
    ];
    settings.trusted-public-keys = [
      "lykos153.cachix.org-1:BLGtaZpIKqZOTOboODw4qGfSasflvle3RFIgUQI2bwQ="
    ];
  };

  security.sudo.extraConfig = ''
    # to make <() work with sudo
    Defaults closefrom_override
    # impermanence results in sudo lectures after each reboot
    Defaults lecture = never
  '';

  boot.supportedFilesystems = ["ntfs" "bcachefs"];
  boot.initrd.systemd.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.udisks2.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    helix
    tmux

    wget
    curl
    git
    dnsutils

    htop

    efibootmgr
    gptfdisk
    parted #for partprobe
    e2fsprogs # for resize2fs
    btrfs-progs
    bindfs
    pciutils
    usbutils
    lshw
    tcpdump

    killall

    footswitch
  ];

  services.udev.packages = [pkgs.footswitch];
}

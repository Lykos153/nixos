# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = map (n: "${./modules}/${n}") (builtins.attrNames (builtins.readDir ./modules));

  nix = {
    package = pkgs.nixVersions.stable;
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

  boot.supportedFilesystems = ["ntfs"];
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
    btrfs-progs
    bindfs
    pciutils
    usbutils
    lshw

    killall
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

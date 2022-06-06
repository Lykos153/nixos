# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
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
    settings.substituters = [
      "https://lykos153.cachix.org"
    ];
    settings.trusted-public-keys = [
      "lykos153.cachix.org-1:BLGtaZpIKqZOTOboODw4qGfSasflvle3RFIgUQI2bwQ="
    ];
  };

  boot.supportedFilesystems = [ "ntfs" ];

  networking.networkmanager.enable = true;

  services.resolved = {
    enable = true;
    fallbackDns = [ "1.1.1.1" "2606:4700:4700::1111,2606:4700:4700::1001" ];
  };

  time.timeZone = "Europe/Berlin";

  networking.useDHCP = false;

  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  services.udisks2.enable = true;

  # https://nixos.wiki/wiki/Printing
  services.printing.enable = true;
  #services.avahi.enable = true; # <- resulted in hangups on silvio-pc
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns = true;


  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  users.users.silvio = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  users.users.mine = {
    uid = 1001;
    isNormalUser = true;
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  users.users.leila = {
    uid = 1002;
    isNormalUser = true;
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  users.users.root.shell = pkgs.zsh;

  # GTK themes.
  #See https://www.reddit.com/r/NixOS/comments/b255k5/home_manager_cannot_set_gnome_themes/
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    tmux

    wget
    curl
    git

    htop

    efibootmgr
    gptfdisk
    parted #for partprobe
    btrfs-progs
    bindfs
    pciutils
    usbutils
    lshw
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  programs.zsh.enable = true;
  programs.zsh.interactiveShellInit = ''
    # Note that loading grml's zshrc here will override NixOS settings such as
    # `programs.zsh.histSize`, so they will have to be set again below.
    source ${pkgs.grml-zsh-config}/etc/zsh/zshrc

    alias d='ls -lah'
    alias g=git

    # Increase history size.
    HISTSIZE=10000000

    # Prompt modifications.
    #
    # In current grml zshrc, changing `$PROMPT` no longer works,
    # and `zstyle` is used instead, see:
    # https://unix.stackexchange.com/questions/656152/why-does-setting-prompt-have-no-effect-in-grmls-zshrc

    # Disable the grml `sad-smiley` on the right for exit codes != 0;
    # it makes copy-pasting out terminal output difficult.
    # Done by setting the `items` of the right-side setup to the empty list
    # (as of writing, the default is `items sad-smiley`).
    # See: https://bts.grml.org/grml/issue2267
    zstyle ':prompt:grml:right:setup' items

    # Add nix-shell indicator that makes clear when we're in nix-shell.
    # Set the prompt items to include it in addition to the defaults:
    # Described in: http://bewatermyfriend.org/p/2013/003/
    function nix_shell_prompt () {
      REPLY=''${IN_NIX_SHELL+"(nix-shell) "}
    }
    grml_theme_add_token nix-shell-indicator -f nix_shell_prompt '%F{magenta}' '%f'
    zstyle ':prompt:grml:left:setup' items rc nix-shell-indicator change-root user at host path vcs percent
  '';
  programs.zsh.promptInit = ""; # otherwise it'll override the grml prompt

  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;

  # Yubikey
  ## Missing prompt issue: https://github.com/Yubico/yubico-pam/issues/208
  ## TODO: Maybe switch to https://github.com/Yubico/pam-u2f
  services.udev.packages = [ pkgs.yubikey-personalization ];
  security.pam = {
    yubico = {
      enable = false; # true would enable for all PAM, including ssh, see https://bytemeta.vip/repo/NixOS/nixpkgs/issues/166076

      debug = false;
      mode = "challenge-response";
      # control = "required"; # Require password AND Yubikey

      # chalresp_path = # TODO using sops-nix
    };
    # Only enable Yubikey for the following services
    services.login.yubicoAuth = true;
    services.swaylock.yubicoAuth = true;
    services.sudo.yubicoAuth = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.tumbler.enable = true;
  # https://unix.stackexchange.com/questions/344402/how-to-unlock-gnome-keyring-automatically-in-nixos
  services.gnome.gnome-keyring.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

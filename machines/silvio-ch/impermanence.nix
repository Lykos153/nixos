{
  config,
  pkgs,
  ...
}: {
  booq.impermanence.enable = true;
  booq.impermanence.persistRoot = "/nix/persist";
  fileSystems."/home" = {
    device = "/nix/tmp-home/current";
    options = ["bind"];
    depends = ["/nix"];
    neededForBoot = true;
  };
  programs.fuse.userAllowOther = true;
  environment.persistence."${config.booq.impermanence.persistRoot}" = {
    directories = builtins.map (user: {
      directory = "/home/${user}";
      inherit user;
      group = "users";
      mode = "u=rwx,g=,o=";
    }) ["mine"];

    users.sa = {
      directories = [
        ".cache"
        ".timewarrior"
        ".talon"
        ".local/share/password-store"
        "opsi-prepare"
        "opsi-data"
        "ghq"
        "devcluster"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".config/age";
          mode = "0700";
        }
        ".local/share/direnv"
        ".local/share/atuin"
        ".thunderbird"
        ".mozilla"
        ".config/Rocket.Chat"
      ];
      files = [
        ".ssh/known_hosts"
      ];
    };

    users.silvio = {
      directories = [
        ".cache"
        ".talon"
        ".local/share/password-store"
        "ghq"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".config/age";
          mode = "0700";
        }
        ".local/share/direnv"
        ".local/share/atuin"
        ".thunderbird"
        ".mozilla"
      ];
      files = [
        ".ssh/known_hosts"
      ];
    };
  };
  boot.initrd.systemd.services.rollback = {
    description = "Rollback bcachefs home subvolume to a pristine state";
    wantedBy = [
      # "initrd.target"
      "sysroot-home.mount"
      "initrd-nixos-activation.service"
      # "initrd-switch-root.target"
    ];
    after = [
      # "sysroot.mount"
      "sysroot-nix.mount"
      # "initrd-fs.target"
    ];
    wants = [
      # "sysroot.mount"
      "sysroot-nix.mount"
    ];
    before = [
      # "initrd-switch-root.target"
      "sysroot-home.mount"
      "initrd-nixos-activation.service"
    ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";

    path = with pkgs; [
      bcachefs-tools
      coreutils
      findutils
      systemd
    ];
    script = ''
      set -x
      # find / -mount
      # find /sysroot -mount
      systemctl list-units --type=mount || true
      prefix=/sysroot/nix/tmp-home
      mv $prefix/current/ $prefix/rollback_$(date +'%s')
      bcachefs subvolume create $prefix/current
    '';
  };
  # systemd.services.activate-silvio = {
  #   description = "Activate last home manager state for silvio";
  #   # wantedBy = [
  #   #   # "initrd.target"
  #   #   "sysroot-home.mount"
  #   #   "initrd-nixos-activation.service"
  #   #   # "initrd-switch-root.target"
  #   # ];
  #   # after = [
  #   #   # "sysroot.mount"
  #   #   "sysroot-nix.mount"
  #   #   # "initrd-fs.target"
  #   # ];
  #   # wants = [
  #   #   # "sysroot.mount"
  #   #   "sysroot-nix.mount"
  #   # ];
  #   # before = [
  #   #   # "initrd-switch-root.target"
  #   #   "sysroot-home.mount"
  #   #   "initrd-nixos-activation.service"
  #   # ];
  #   # unitConfig.DefaultDependencies = "no";
  #   serviceConfig.Type = "oneshot";

  #   # path = with pkgs; [
  #   # ];
  #   serviceConfig.User = "silvio";
  #   script = ''
  #     set -x
  #     /home/silvio/.local/state/home-manager/gcroots/current-home/activate
  #   '';
  # };
}

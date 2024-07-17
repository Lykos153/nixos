{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.booq.tools;
in {
  options.booq.tools = {
    enable = lib.mkEnableOption "";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vim
      helix
      zellij

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
      keyutils # for encrypted bcachefs

      killall
    ];
  };
}

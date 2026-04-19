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
      bindfs
      btrfs-progs
      cryptsetup
      curl
      dnsutils
      e2fsprogs # for resize2fs
      efibootmgr
      git
      gptfdisk
      helix
      htop
      keyutils # for encrypted bcachefs
      killall
      lshw
      parted #for partprobe
      pciutils
      tcpdump
      usbutils
      vim
      wget
      wireguard-tools
      zellij
    ];
  };
}

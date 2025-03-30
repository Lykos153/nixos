{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.initrd.systemd.enable = false;

  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor pkgs.linux_testing);

  fileSystems."/bcachefs" = {
    device = "UUID=677cf0a7-1abe-4ce3-876c-2ca63301229d";
    fsType = "bcachefs";
    options = ["compression=zstd"];
    neededForBoot = true;
  };
  specialisation.fsck.configuration.fileSystems."/bcachefs".options = ["fsck" "fix_errors"];
  specialisation.very_degraded.configuration.fileSystems."/bcachefs".options = ["very_degraded" "verbose"];

  systemd.services.bcachefs-snapshot-home = {
    description = "Create a snapshot of the home subvolume";
    after = [
      "bcachefs.mount"
    ];
    serviceConfig.Type = "oneshot";

    path = with pkgs; [
      bcachefs-tools
      coreutils
    ];
    script = ''
      set -x
      bcachefs subvolume snapshot /bcachefs/home "/bcachefs/snapshots/home.$(date '+%Y-%m-%d.%H%M')" -r
    '';
  };

  systemd.timers.bcachefs-snapshot-home = {
    timerConfig = {
      OnCalendar = "daily";
      RandomizedDelaySec = 3600;
      Persistent = true;
      Unit = config.systemd.services.bcachefs-snapshot-home.name;
    };
  };
}

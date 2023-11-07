# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  luksDev = {
    root = "root";
    home = "home";
    swap = "swap";
  };
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  # TODO: disko
  boot.initrd.luks.devices."${luksDev.root}".device = "/dev/disk/by-uuid/22a113fb-fd79-40bf-8d28-53abe042fcef";
  boot.initrd.luks.devices."${luksDev.home}".device = "/dev/disk/by-uuid/ae264b70-6cfc-49e3-9777-213e0c1b6169";
  boot.initrd.luks.devices."${luksDev.swap}".device = "/dev/disk/by-uuid/7dfd5430-906b-4826-a38a-0fcb0818c1ad";

  fileSystems."/" = {
    device = "/dev/mapper/${luksDev.root}";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/EAD8-E590";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/mapper/${luksDev.home}";
    fsType = "ext4";
  };

  swapDevices = [
    {
      device = "/dev/mapper/${luksDev.swap}";
    }
  ];
  boot.kernel.sysctl."vm.swappiness" = 0; # Use swap only for hibernate

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b2190b16-d622-4def-8b3d-399121e70643";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."nixos-root".device = "/dev/disk/by-uuid/01ee06fc-5814-4144-b9ee-e6e508e27094";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/1946-5E3F";
      fsType = "vfat";
    };

  swapDevices = [
    {
      device = "/var/swap";
      size = 1024 * 4;
    }
  ];

  hardware.cpu.intel.updateMicrocode = true;
}

{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "e1000e"];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  # Blacklist nvidia because it's annoying.
  # TODO: pcie passthrough using ie. https://github.com/CRTified/nur-packages
  boot.blacklistedKernelModules = [ "nvidia" "nouveau" ];


  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  hardware.cpu.intel.updateMicrocode = true;

  fileSystems."/" =
    { device = "/dev/mapper/arch-root";
      fsType = "btrfs";
      options = [ "subvol=nixos" ];
    };
  fileSystems."/btrfs" =
    { device = "/dev/mapper/arch-root";
      fsType = "btrfs";
      options = [ "subvol=/" ];
    };
  fileSystems."/boot".device = "/dev/disk/by-uuid/9E7D-E776";
}

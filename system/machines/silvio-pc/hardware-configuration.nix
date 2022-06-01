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

  boot.initrd.luks.devices."arch-root".device = "/dev/disk/by-uuid/b474463d-7d93-4abf-95cd-35db2f9a6490";
  boot.initrd.luks.devices."arch-root2".device = "/dev/disk/by-uuid/efae7e7f-5c77-4957-9a75-f2862e620d15";
  boot.initrd.luks.devices."arch-root3".device = "/dev/disk/by-uuid/d55b7110-02b2-47fd-9441-bf53c67eeccc";

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  hardware.cpu.intel.updateMicrocode = true;
}

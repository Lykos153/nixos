{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "nvme" "usbhid" "usb_storage" "e1000e" "sd_mod"];
  boot.initrd.kernelModules = ["dm-snapshot"];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  hardware.cpu.intel.updateMicrocode = true;
}

{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
      ./services.nix
    ];

  networking.hostName = "silvio-pc";

  hardware.cpu.intel.updateMicrocode = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "e1000e"];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.initrd.network.enable = true;
  boot.initrd.network.ssh = {
    enable = true;
    port = 2222;
    authorizedKeys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDiiFMvNKabUfl1A0KK4GuS46sbMw38E0+/gQQpybindA2+QlfpWurBws6VndPOQjPiYftKr+UigbrwBZBQgCdvQ4lZP9lbd4W1R72zrVmKugb8SMmJUPavUGia+h7huZXebE7Zd4/c8vsHmZiRUGVAWTLX3pET/0p3E3n5dzqK8cI0ZdlwoM3+u5x3mGwXRY5qfgcJ8rm8/hGpSPRAxubLDfVuBJ/8zakNq9QbgUFAEZEPSGQ5SEfmxYTapsjI0Inqs6rEb+q9XgXazcxFLi/VXiO1uFyPWJCEn4PKpI7d7mF6uMbO5UTrPYgITGuNqbT+qEK4PYALixisOR0uV4tx silvio@arch-stick"
    ];
    hostKeys = [ "/etc/secrets/initrd/ssh_host_rsa_key" "/etc/secrets/initrd/ssh_host_ed25519_key" ];
  };
  boot.kernelParams = [ "ip=192.168.1.53::192.168.1.1:255.255.255.0:::" ];
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
}

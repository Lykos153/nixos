{pkgs, ...}: {
  booq.virtualisation = {
    enable = true;
    libvirtUsers = ["silvio" "sa"];
  };

  virtualisation.vfio = {
    enable = true;
    IOMMUType = "intel";
    devices = [
      "10de:1380" # NVIDIA Corporation GM107 [GeForce GTX 750 Ti]
      "10de:0fbc" # NVIDIA Corporation GM107 High Definition Audio Controller [GeForce 940MX]
    ];
    blacklistNvidia = true;
    applyACSpatch = false; # TODO fix upstream
  };

  # workaround for dysfunctional option upstream
  # boot.kernelParams = [
  #   "pcie_acs_override=downstream,multifunction"
  #   "pci=nomsi"
  # ];
  # boot.kernelPatches = [
  #   {
  #     name = "add-acs-overrides";
  #     patch = pkgs.fetchurl {
  #       name = "add-acs-overrides.patch";
  #       url = "https://aur.archlinux.org/cgit/aur.git/plain/1001-6.6.7-add-acs-overrides.patch?h=linux-vfio&id=3d7255075f74ae27d4bddfc9c18f8e434e8255d3";
  #       sha256 = "sha256-80KYa9J5gMlslSsN2BA9PiGpQth/GN8TCPqzcOIAEPs=";
  #     };
  #   }
  #   {
  #     name = "i915-vga-arbiter";
  #     patch = pkgs.fetchurl {
  #       name = "i915-vga-arbiter.patch";
  #       url = "https://aur.archlinux.org/cgit/aur.git/plain/1002-6.6.7-i915-vga-arbiter.patch?h=linux-vfio&id=3d7255075f74ae27d4bddfc9c18f8e434e8255d3";
  #       sha256 = "sha256-KjxzLU1hpjHJiyo+Svsfpdv4vlxDUZsqWdDmUXDJ2Ns=";
  #     };
  #   }
  # ];
}

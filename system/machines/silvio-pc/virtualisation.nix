{pkgs, ...}: {
  booq.virtualisation = {
    enable = true;
    libvirtUsers = ["silvio" "sa"];
  };

  boot.kernelParams = ["intel_iommu=on" "vfio-pci.ids=10de:1380,10de:0fbc"];
  boot.kernelModules = ["vfio-pci"];

  # Blacklist nvidia because it's annoying.
  # TODO: pcie passthrough using ie. https://github.com/CRTified/nur-packages
  boot.blacklistedKernelModules = ["nvidia" "nouveau"];
}

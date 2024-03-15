{pkgs, ...}: {
  booq.virtualisation = {
    enable = true;
    libvirtUsers = ["silvio" "sa"];
  };

  boot.kernelParams = ["intel_iommu=on"];

  # Blacklist nvidia because it's annoying.
  # TODO: pcie passthrough using ie. https://github.com/CRTified/nur-packages
  boot.blacklistedKernelModules = ["nvidia" "nouveau"];
}

{config, ...}: {
  boot.kernelModules = ["nullfs"];
  boot.extraModulePackages = [config.boot.kernelPackages.nullfs];

  fileSystems."/run/null" = {
    device = "none";
    fsType = "nullfs";
  };
}

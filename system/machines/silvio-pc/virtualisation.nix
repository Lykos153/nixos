{pkgs, ...}:
{
  users.users.silvio.extraGroups = [ "libvirtd" ];
  environment.systemPackages = with pkgs; [ virt-manager ];

  virtualisation.libvirtd.enable = true;

  # Blacklist nvidia because it's annoying.
  # TODO: pcie passthrough using ie. https://github.com/CRTified/nur-packages
  boot.blacklistedKernelModules = [ "nvidia" "nouveau" ];
}

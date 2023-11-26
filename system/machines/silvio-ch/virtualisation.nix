{pkgs, ...}: {
  users.users.silvio.extraGroups = ["libvirtd"];
  users.users.sa.extraGroups = ["libvirtd"];
  environment.systemPackages = with pkgs; [virt-manager];

  virtualisation.libvirtd.enable = true;
}

{pkgs, ...}: {
  users.users.silvio.extraGroups = ["libvirtd"];
  environment.systemPackages = with pkgs; [virt-manager];

  virtualisation.libvirtd.enable = true;
}

{
  boot.kernelModules = [ "mac80211_hwsim" ];

  users.users.silvio.extraGroups = [ "libvirtd" "wireshark" ];

  virtualisation.libvirtd.enable = true;
  # virtualisation.virtualbox.host.enable = true;

  programs.wireshark.enable = true;
}
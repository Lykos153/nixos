{
  boot.kernelModules = [ "mac80211_hwsim" ];

  users.users.silvio.extraGroups = [ "libvirtd" "wireshark" ];

  virtualisation.libvirtd.enable = true;
  # virtualisation.virtualbox.host.enable = true;

  services.nfs.server.enable = true;
  networking.firewall.extraCommands = ''
    ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
  '';

  programs.wireshark.enable = true;
}

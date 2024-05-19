{
  lib,
  config,
  ...
}: {
  networking.useNetworkd = true;
  networking.useDHCP = false;
  networking.networkmanager.enable = false;

  services.resolved = {
    enable = true;
    fallbackDns = ["1.1.1.1" "2606:4700:4700::1111,2606:4700:4700::1001"];
  };

  networking.firewall.enable = true;
  networking.nftables.enable = config.booq.lib.mkMyDefault true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  systemd.network.enable = true;
  networking.wireless.enable = true;

  systemd.network.networks."10-lan" = {
    matchConfig.Name = "en*";
    networkConfig.DHCP = "yes";
    networkConfig.DNSSEC = "no"; # seems to be broken here
    # dhcpConfig.UseDNS = false;
  };
  systemd.network.networks."20-wlan" = {
    matchConfig.Name = "wl*";
    networkConfig.DHCP = "yes";
    networkConfig.DNSSEC = "no"; # seems to be broken here
    # dhcpConfig.UseDNS = false;
    dhcpConfig.RouteMetric = 1025;
  };
  systemd.network.wait-online.anyInterface = true;

  sops.secrets = lib.mkIf config.booq.sops.enable {
    "wpa_supplicant.conf" = {
      path = "/etc/wpa_supplicant.conf";
      sopsFile = ./secrets.yaml;
    };
  };
}

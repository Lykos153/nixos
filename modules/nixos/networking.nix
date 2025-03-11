{
  lib,
  options,
  config,
  ...
}: let
  cfg = config.booq.networking;
in {
  options.booq.networking = {
    enable = lib.mkEnableOption "Networking";
    sopsFile = lib.mkOption {
      type = lib.types.path;
    };
    networkmanager = lib.mkEnableOption "NetworkManager";
  };
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        networking.useDHCP = false;
        services.resolved = {
          enable = true;
          fallbackDns = ["1.1.1.1" "2606:4700:4700::1111,2606:4700:4700::1001"];
        };
        networking.firewall.enable = true;
        networking.nftables.enable = config.booq.lib.mkMyDefault true;
        # Open ports in the firewall.
        # networking.firewall.allowedTCPPorts = [ ... ];
        # networking.firewall.allowedUDPPorts = [ ... ];

        networking.networkmanager.enable = cfg.networkmanager;
      }
      (
        lib.mkIf (!cfg.networkmanager) (
          {
            networking.useNetworkd = true;

            systemd.network.enable = true;
            networking.wireless.enable = true;

            systemd.network.networks."10-lan" = {
              matchConfig.Name = "en*";
              networkConfig.DHCP = "yes";
              networkConfig.DNSSEC = "no"; # seems to be broken here
              dhcpConfig.UseDNS = false;
              dhcpV4Config.RouteMetric = 1024;
              dhcpV6Config.RouteMetric = 1024;
            };
            systemd.network.networks."20-wlan" = {
              matchConfig.Name = "wl*";
              networkConfig.DHCP = "yes";
              networkConfig.DNSSEC = "no"; # seems to be broken here
              dhcpConfig.UseDNS = false;
              dhcpV4Config.RouteMetric = 1025;
              dhcpV6Config.RouteMetric = 1025;
            };
            systemd.network.wait-online.anyInterface = true;
          }
          // (
            lib.optionalAttrs (options ? "sops") {
              sops.secrets = lib.optionalAttrs config.booq.sops.enable {
                "wpa_supplicant.conf" = {
                  path = "/etc/wpa_supplicant.conf";
                  inherit (cfg) sopsFile;
                };
              };
            }
          )
        )
      )
    ]
  );
}

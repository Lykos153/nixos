{
  lib,
  config,
  ...
}: let
  cfg = config.booq.local.openvpn-ch;
in {
  options.booq.local.openvpn-ch.enable = lib.mkEnableOption "openvpn-ch";
  options.booq.local.openvpn-ch.routes = lib.mkOption {
    type = lib.types.strMatching "all|per-network|per-ip";
    default = "per-network";
  };

  config = lib.mkIf cfg.enable {
    # Trying to fix SSH sessions stuck at SSH2_MSG_KEXINIT sent
    boot.kernel.sysctl."net.ipv4.tcp_mtu_probing" = 1;

    sops.secrets = builtins.foldl' (acc: file:
      acc
      // {
        "openvpn-ch/${file}" = {
          key = "${file}";
          sopsFile = ./secrets.yaml;
        };
      }) {} ["ch.conf" "routes-per-network.conf" "routes-per-ip.conf" "ca.crt" "sa.crt"];

    services.openvpn.servers = {
      ch = {
        config =
          ''
            client
            dev tap
            proto tcp
            nobind
            auth-nocache
            script-security 2
            persist-key
            persist-tun
            auth SHA512
            remote-cert-tls server
            comp-lzo

            config ${config.sops.secrets."openvpn-ch/ch.conf".path}
            ca ${config.sops.secrets."openvpn-ch/ca.crt".path}
            cert ${config.sops.secrets."openvpn-ch/sa.crt".path}
            key ${config.booq.impermanence.persistRoot}/root/secrets/sa.key
          ''
          + (builtins.getAttr cfg.routes {
            "per-network" = ''
              config ${config.sops.secrets."openvpn-ch/routes-per-network.conf".path}
            '';
            "per-ip" = ''
              config ${config.sops.secrets."openvpn-ch/routes-per-ip.conf".path}
            '';
            "all" = "";
          });
      };
    };
  };
}

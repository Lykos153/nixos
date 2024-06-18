{
  lib,
  config,
  ...
}: let
  cfg = config.booq.local.openvpn-ch;
in {
  options.booq.local.openvpn-ch.enable = lib.mkEnableOption "openvpn-ch";

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
      }) {} ["ch.conf" "ca.crt" "sa.crt"];

    services.openvpn.servers = {
      ch = {
        config = ''
          client
          cipher AES-256-CBC
          dev tap
          proto tcp
          nobind
          auth-nocache
          script-security 2
          persist-key
          persist-tun
          #link-mtu 1492
          auth SHA512
          remote-cert-tls server
          comp-lzo

          mssfix 1280

          config ${config.sops.secrets."openvpn-ch/ch.conf".path}
          ca ${config.sops.secrets."openvpn-ch/ca.crt".path}
          cert ${config.sops.secrets."openvpn-ch/sa.crt".path}
          key ${config.booq.impermanence.persistRoot}/root/secrets/sa.key
        '';
      };
    };
  };
}

{config, ...}: {
  # Trying to fix SSH sessions stuck at SSH2_MSG_KEXINIT sent
  boot.kernel.sysctl."net.ipv4.tcp_mtu_probing" = 1;

  services.openvpn.servers = {
    ch = {config = ''config ${config.booq.impermanence.persistRoot}/root/secrets/openvpn_ch.conf '';};
  };
}

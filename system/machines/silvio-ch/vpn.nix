{config, ...}: {
  services.openvpn.servers = {
    ch = {config = ''config ${config.booq.impermanence.persistRoot}/root/secrets/openvpn_ch.conf '';};
  };
}

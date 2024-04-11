{
  lancache = {
    dns = {
      enable = true;
      forwarders = ["1.1.1.1" "8.8.8.8"];
      cacheIp = "192.168.1.241";
    };
    cache = {
      enable = true;
      resolvers = ["1.1.1.1" "8.8.8.8"];
      cacheDir = "/hdd/lancache";
    };
  };
}

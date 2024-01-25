{
  fileSystems."/new" = {
    device = "UUID=df92732a-7143-475c-b245-39486003b161";
    # device = "/dev/disk/by-id/wwn-0x5000c5005cc4c974-part1:/dev/disk/by-id/nvme-Viper_M.2_VP4100_7F60070C189D89246969-part1";
    fsType = "bcachefs";
    # options = [ "compression=zstd" ];

    neededForBoot = true;
  };
}

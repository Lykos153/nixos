{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    footswitch
  ];

  services.udev.packages = [pkgs.footswitch];
}

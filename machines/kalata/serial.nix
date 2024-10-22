{
  boot.kernelParams = [
    "console=ttyS0,115200n8"
  ];
  boot.loader.grub = {
    enable = true;
    extraConfig = "
   serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1
   terminal_input serial
   terminal_output serial
 ";
  };
}

{
  config,
  lib,
  ...
}:
lib.mkIf (config.booq.gui.enable && config.booq.gui.sway.enable) {
  services.kanshi = {
    enable = true;
    profiles = {
      home_kvm_disabled.outputs = [
        {
          criteria = "BNQ BenQ GL2450H 76H05996019";
          status = "disable";
        }
        {
          criteria = "Samsung Electric Company SAMSUNG 0x00000001";
          status = "disable";
        }
      ];
      home.outputs = [
        {
          criteria = "Samsung Electric Company SyncMaster HMBB602462";
          mode = "1920x1200";
          position = "3000,540";
          status = "enable";
        }
        {
          criteria = "BNQ BenQ GL2450H 76H05996019";
          mode = "1920x1080";
          position = "1920,0";
          transform = "270";
          status = "enable";
        }
        {
          criteria = "Samsung Electric Company SAMSUNG 0x00000001";
          mode = "1920x1080";
          position = "4920,540";
          status = "disable";
        }
      ];
      home_no_tv.outputs = [
        {
          criteria = "Samsung Electric Company SyncMaster HMBB602462";
          mode = "1920x1200";
          position = "3000,540";
          status = "enable";
        }
        {
          criteria = "BNQ BenQ GL2450H 76H05996019";
          mode = "1920x1080";
          position = "1920,0";
          transform = "270";
          status = "enable";
        }
      ];
      home_no_tv_kvm_disabled.outputs = [
        {
          criteria = "BNQ BenQ GL2450H 76H05996019";
          status = "disable";
        }
      ];
      berlin.outputs = [
        {
          criteria = "Fujitsu Siemens Computers GmbH B24-8 TS Pro YV9T711375";
          mode = "1920x1080";
          position = "0,0";
          transform = "90";
        }
        {
          criteria = "Fujitsu Siemens Computers GmbH B24-8 TS Pro YV9T711377";
          mode = "1920x1080";
          position = "1080,450";
        }
      ];
      leilasus.outputs = [
        {
          criteria = "Philips Consumer Electronics Company Philips FTV 0x00000101";
          mode = "1920x1080";
          position = "0,0";
          scale = 1.6;
        }
        {
          criteria = "BNQ BenQ GL2450H HAF04109019";
          mode = "1920x1080";
          position = "1200,0";
        }
      ];
      leilasus-onlybenq.outputs = [
        {
          criteria = "BNQ BenQ GL2450H HAF04109019";
          mode = "1920x1080";
          position = "1200,0";
        }
      ];
      leilasus-onlytv.outputs = [
        {
          criteria = "Philips Consumer Electronics Company Philips FTV 0x00000101";
          mode = "1920x1080";
          position = "0,0";
          scale = 1.6;
        }
      ];
      ch-mobile.outputs = [
        {
          criteria = "AU Optronics 0x103D Unknown";
          mode = "1920x1080";
          position = "0,0";
          scale = 1.2;
        }
      ];
      ch.outputs = [
        {
          criteria = "AU Optronics 0x103D Unknown";
          mode = "1920x1080";
          position = "4902,2660";
          scale = 1.5;
        }
        {
          criteria = "Unknown HL274HPB 0x00000000";
          mode = "1920x1080";
          position = "6182,2110";
        }
      ];
      ch-home.outputs = [
        {
          criteria = "AU Optronics 0x103D Unknown";
          mode = "1920x1080";
          position = "443,1089";
          scale = 1.300781;
          status = "enable";
        }
        {
          criteria = "Samsung Electric Company SyncMaster HMBB602462";
          mode = "1920x1200";
          position = "3840,0";
          status = "enable";
          transform = "90";
        }
        {
          criteria = "BNQ BenQ GL2450H 76H05996019";
          mode = "1920x1080";
          position = "1920,840";
          status = "enable";
        }
      ];
      ch-home-kvm-disabled.outputs = [
        {
          criteria = "AU Optronics 0x103D Unknown";
          mode = "1920x1080";
          position = "5441,1019";
          scale = 1.601562;
        }
        {
          criteria = "BNQ BenQ GL2450H 76H05996019";
          status = "disable";
        }
      ];
      ch-leila.outputs = [
        {
          criteria = "AU Optronics 0x103D Unknown";
          mode = "1920x1080";
          position = "0,740";
          scale = 1.5;
        }
        {
          criteria = "Philips Consumer Electronics Company PHL 243V5 ZV01626032761";
          mode = "1920x1080";
          position = "1280,200";
        }
      ];
      ch-papa.outputs = [
        {
          criteria = "AU Optronics 0x103D Unknown";
          mode = "1920x1080";
          position = "5441,820";
          scale = 1.5;
        }
        {
          criteria = "Ancor Communications Inc ASUS VS229 HCLMQS082378";
          mode = "1920x1080";
          position = "3521,660";
        }
        {
          criteria = "Acer Technologies CB242Y 0x0000F384";
          mode = "1920x1080";
          position = "1601,460";
        }
      ];
    };
  };
}

{ config, lib, ... }:
lib.mkIf (config.booq.gui.enable && config.booq.gui.sway.enable) {
  services.kanshi = {
    enable = true;
    profiles = {
      home.outputs = [
        {
          criteria = "Samsung Electric Company SyncMaster HMBB602462";
          mode = "1920x1200";
          position = "3000,540";
        }
        {
          criteria = "BenQ Corporation BenQ GL2450H 76H05996019";
          mode = "1920x1080";
          position = "1920,0";
          transform = "270";
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
        }
        {
          criteria = "BenQ Corporation BenQ GL2450H 76H05996019";
          mode = "1920x1080";
          position = "1920,0";
          transform = "270";
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
          criteria = "BenQ Corporation BenQ GL2450H HAF04109019";
          mode = "1920x1080";
          position = "1200,0";
        }
      ];
      leilasus-onlybenq.outputs = [
        {
          criteria = "BenQ Corporation BenQ GL2450H HAF04109019";
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
          criteria = "Unknown 0x103D 0x00000000";
          mode = "1920x1080";
          position = "0,0";
          scale = 1.2;
        }
      ];
      ch.outputs = [
        {
          criteria = "Unknown 0x103D 0x00000000";
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
          criteria = "Unknown 0x103D 0x00000000";
          mode = "1920x1080";
          position = "5441,1019";
          scale = 1.601562;
        }
        {
          criteria = "Samsung Electric Company SyncMaster HMBB602462";
          mode = "1920x1200";
          position = "3521,350";
        }
        {
          criteria = "BenQ Corporation BenQ GL2450H 76H05996019";
          mode = "1920x1080";
          position = "2441,0";
          transform = "270";
        }
      ];
      ch-leila.outputs = [
        {
          criteria = "Unknown 0x103D 0x00000000";
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
          criteria = "Unknown 0x103D 0x00000000";
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

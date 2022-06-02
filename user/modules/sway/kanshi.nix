{
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
    };
  };
}

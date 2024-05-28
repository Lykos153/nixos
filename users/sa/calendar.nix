{pkgs, ...}: let
  url = "https://nextcloud.cloudandheat.com";
  userName = "silvio.ankermann";
  passwordCommand = ["pass" "show" "nextcloud/vdirsyncer"];
in {
  programs.vdirsyncer.enable = true;
  programs.khal.enable = true;
  accounts.calendar = {
    basePath = ".local/share/calendars";
    accounts.nextcloud = {
      vdirsyncer = {
        enable = true;
        conflictResolution = "remote wins";
        collections = [
          "personal"
          # "vacation_shared_by_admin"
          "feiertage-sachsen-1_shared_by_admin"
          "mitarbeiter_shared_by_admin"
          "dailies_shared_by_duty-bot"
          "la_shared_by_admin"
          "maintenance_shared_by_admin"
          "customer-consultations_shared_by_duty-bot"
          "opsi-blocker_shared_by_duty-bot"
        ];
      };
      khal = {
        enable = true;
        type = "discover";
      };
      primaryCollection = "personal";
      local = {
        type = "filesystem";
        fileExt = ".ics";
      };
      remote = {
        type = "caldav";
        url = url;
        userName = userName;
        passwordCommand = passwordCommand;
      };
    };
  };
  accounts.contact = {
    basePath = ".local/share/contacts";
    accounts.nextcloud = {
      vdirsyncer = {
        enable = true;
        conflictResolution = "remote wins";
        collections = [
          "contacts"
          "cloudandheat_shared_by_admin"
        ];
      };
      local = {
        type = "filesystem";
        fileExt = ".vcf";
      };
      remote = {
        type = "carddav";
        url = url;
        userName = userName;
        passwordCommand = passwordCommand;
      };
    };
  };
}

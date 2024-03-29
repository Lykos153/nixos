{pkgs, ...}: {
  programs.gpg = {
    enable = true;
    settings = {
      keyserver = "hkp://keys.gnupg.net";
    };
    scdaemonSettings = {
      disable-ccid = true;
    };
    publicKeys = [
      {
        source = ./pubkeys/A63BA766.gpg;
        trust = 5;
      }
      {
        source = ./pubkeys/8D4762947205541C62A49C88F4226CA3971C4E97.gpg;
        trust = 5;
      }
    ];
  };

  services.gpg-agent = {
    enable = true;

    defaultCacheTtl = 86400;
    defaultCacheTtlSsh = 86400;
    maxCacheTtl = 86400;
    maxCacheTtlSsh = 86400;
    enableSshSupport = true;
    extraConfig =
      ''
        pinentry-program ${pkgs.pinentry-qt}/bin/pinentry
      ''
      + ''
        allow-loopback-pinentry
      '';
  };
}

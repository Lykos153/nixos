{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; {
  imports =
    map (n: "${./.}/${n}") (filter (n: n != "default.nix") (attrNames (readDir ./.)));
  config = let
    okular-x11 = pkgs.symlinkJoin {
      name = "okular";
      paths = [pkgs.okular];
      buildInputs = [pkgs.makeWrapper];
      # force okular to use xwayland, because of https://github.com/swaywm/sway/issues/4973
      postBuild = ''
        wrapProgram $out/bin/okular \
          --set QT_QPA_PLATFORM xcb
      '';
    };
  in
    lib.mkIf config.booq.gui.enable {
      home.packages = with pkgs; [
        termite
        gajim
        element-desktop
        fractal
        pavucontrol
        libreoffice
        nomacs
        okular-x11
        xfce.thunar
        vlc
        system-config-printer
        wireshark
        lykos153.cb
        feh
      ];
      xdg.mimeApps.defaultApplications = {
        "application/pdf" = "okularApplication_pdf.desktop";
        "inode/directory" = "thunar.desktop";
      };
    };
}

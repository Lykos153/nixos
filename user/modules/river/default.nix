{pkgs, ...}: {
  home.packages = with pkgs; [
    river
  ];
  xdg.configFile."river/init" = {
    executable = true;
    text = ''
      #!${pkgs.nushell}/bin/nu
      riverctl map normal Super+Shift Return spawn ${pkgs.foot}/bin/foot
    '';
  };
}

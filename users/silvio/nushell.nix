{pkgs, ...}: {
  programs.nushell = {
    extraConfig = ''
      def --env gq [--code] {
        let menu = if $code {{|| ${pkgs.rofi}/bin/rofi -dmenu -i}} else {{|| ${pkgs.skim}/bin/sk}}
        let dir = ls ~/ghq/*/*/* | where type == dir | get name | to text | do $menu | str trim
        if $code and ($dir != "") {
          code $dir
        } else {
          cd $dir
        }
      }
    '';
  };
}

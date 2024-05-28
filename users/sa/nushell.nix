{pkgs, ...}: {
  programs.nushell = {
    extraConfig = ''
      def --env cl [] {cd (ls ~/clusters/*/* | get name | to text | ${pkgs.skim}/bin/sk)}
      def --env gq [] {cd (ls ~/ghq/*/*/* | where type == dir | get name | to text | ${pkgs.skim}/bin/sk)}
    '';
  };
}

{pkgs, ...}: {
  programs.nushell = {
    extraConfig = ''
      def --env cl [] {cd (ls ~/clusters/*/* | get name | to text | ${pkgs.skim}/bin/sk)}
      def --env gq [] {cd (fd -H "^.git$" ~/ghq/ | lines | path parse | get parent | to text | ${pkgs.skim}/bin/sk)}
    '';
  };
}

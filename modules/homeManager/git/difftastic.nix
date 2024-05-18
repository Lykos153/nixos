{pkgs, ...}: {
  programs.git = {
    difftastic.enable = true;
    extraConfig = {
      # diff.tool = "difftastic";
    };
  };

  home.packages = [
    pkgs.difftastic
  ];
}

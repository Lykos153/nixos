{
  programs.zsh.shellAliases = {
    cal = "cal -3 --week --iso";
    dirs = "dirs -v";

    hmb = "_hm_nix_build_switch build user";
    hms = "_hm_nix_build_switch switch user";
    renix = "_hm_nix_build_switch switch system";
    testnix = "_hm_nix_build_switch test system";
    nix = "noglob nix";

    helpme = "remote-debug";
  };
}

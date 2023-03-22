{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-nix
    ];

    extraConfig = ''
                set cc=80
                set number
                set mouse=
    '';
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  # workaround because the above doesnt seem to work in xorg https://github.com/nix-community/home-manager/issues/1011#issuecomment-1365065753
  programs.zsh.initExtra = ''
    export EDITOR="nvim"
  '';
}

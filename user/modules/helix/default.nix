{
  pkgs,
  lib,
  ...
}: {
  programs.helix = {
    enable = true;
    settings =
      (fromTOML (builtins.readFile ./config.toml))
      // {
        theme = lib.mkDefault "onedark";
      };
    # defaultEditor = true;
  };
  home.packages = [
    # Language servers
    # https://docs.helix-editor.com/lang-support.html
    pkgs.nil # Nix
    # pkgs.taplo # toml
    pkgs.yaml-language-server
    pkgs.python3Packages.python-lsp-server # Python
    pkgs.marksman # Markdown
    pkgs.gopls # Go
    #pkgs.docker-langserver
    #pkgs.bash-language-server
    pkgs.terraform-ls
    # pkgs.vscode-json-language-server
    pkgs.jsonnet-language-server
    pkgs.rust-analyzer
  ];
  home.sessionVariables = {
    EDITOR = "hx";
  };
  # workaround because the above doesnt seem to work in xorg https://github.com/nix-community/home-manager/issues/1011#issuecomment-1365065753
  programs.zsh.initExtra = ''
    export EDITOR="hx"
  '';
}

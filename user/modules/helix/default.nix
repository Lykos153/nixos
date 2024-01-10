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
    languages = {
      language-server.ltex.command = pkgs.ltex-ls;
      language = [
        {
          name = "markdown";
          language-servers = [{name = "ltex";}];
          file-types = ["md" "txt"];
          scope = "text.markdown";
          roots = [];
        }
      ];
    };
    defaultEditor = true;
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
  # # workaround because defaultEditor doesnt seem to work in xorg https://github.com/nix-community/home-manager/issues/1011#issuecomment-1365065753
  # programs.zsh.initExtra = ''
  #   export EDITOR="hx"
  # '';
}

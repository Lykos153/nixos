{ pkgs, ... }:
{
  home.packages = [
    pkgs.helix

    # Language servers
    # https://docs.helix-editor.com/lang-support.html
    pkgs.nil # Nix
    pkgs.taplo # toml
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
  xdg.configFile."helix/config.toml".source = ./config.toml;
}

{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.booq.helix;
in {
  options.booq.helix = {
    enable = lib.mkEnableOption "helix";
    enableLanguageServers = lib.mkEnableOption "helix-languageservers";
  };
  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;
      settings = {
        theme = lib.mkDefault "onedark";

        keys = {
          normal = {
            Z = {
              Q = ":quit!";
              Z = ":x";
            };
          };
        };

        editor = {
          mouse = false;
          auto-format = false;
          auto-pairs = true;
          lsp = {
            display-messages = true;
          };
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          file-picker = {
            hidden = false;
          };
          soft-wrap = {
            enable = true;
          };
        };
      };
      defaultEditor = true;
    };
    home.packages = lib.optionals cfg.enableLanguageServers [
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
  };
}

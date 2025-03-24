{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.booq.languageServers;
in {
  options.booq.languageServers.enable = lib.mkEnableOption "language servers";
  config = lib.mkIf cfg.enable {
    home.packages = [
      # Language servers
      # https://docs.helix-editor.com/lang-support.html
      pkgs.nil # Nix
      pkgs.nixd # Nix
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

    programs.vscode.userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
    };

    programs.helix.languages = {
      language = [
        {
          name = "nix";
          language-servers = [
            "nixd"
            "nil"
          ];
        }
      ];
      language-server = {
        nixd = {
          command = "nixd";
        };
      };
    };
  };
}

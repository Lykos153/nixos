{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.booq.vscode;
in {
  options = {
    booq.vscode.useBlack = lib.mkEnableOption "Use Black formatter for Python";
  };
  config = lib.mkIf config.booq.gui.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      userSettings = {
        "[nix]"."editor.tabSize" = 2;
        "alejandra.program" = "${pkgs.alejandra}/bin/alejandra";
        "files.insertFinalNewline" = true;
        "editor.acceptSuggestionOnEnter" = "off";
        "editor.fontFamily" = "'FuraCode Mono Nerd Font', 'monospace', monospace";
        "workbench.colorTheme" = "Default Dark+";
        "[python]" =
          {
            "editor.formatOnSave" = true;
          }
          // lib.attrsets.optionalAttrs cfg.useBlack {
            "editor.defaultFormatter" = "ms-python.black-formatter"; # needs extension to be present
          };
        "redhat.telemetry.enabled" = false;
        "cursorless.colors.dark" = {
          "default" = "#AAA7BB";
          "blue" = "#0870FF";
          "green" = "#36CC3F";
          "red" = "#992222";
          "pink" = "#FE7F9C";
          "yellow" = "#E5C02C";
        };
      };
      keybindings = [
        {
          key = "alt+t";
          command = "go.test.cursor";
        }
      ];
      extensions = with pkgs;
        [
          vscode-extensions.yzhang.markdown-all-in-one
          vscode-extensions.jnoortheen.nix-ide
          vscode-extensions.ms-python.python
          vscode-extensions.hashicorp.terraform
          vscode-extensions.ms-azuretools.vscode-docker
          vscode-extensions.james-yu.latex-workshop
          vscode-extensions.ms-ceintl.vscode-language-pack-de
          vscode-extensions.redhat.vscode-yaml
          vscode-extensions.kamadorueda.alejandra
          vscode-extensions.bungcip.better-toml
          vscode-extensions.thenuprojectcontributors.vscode-nushell-lang
          vscode-extensions.golang.go
          vscode-extensions.timonwong.shellcheck
          open-vsx.codeium.codeium
          open-vsx.zardoy.fix-all-json
          open-vsx.hirse.vscode-ungit
          open-vsx.ipedrazas.kubernetes-snippets
          open-vsx.tumido.crd-snippets
          vscode-marketplace.ast-grep.ast-grep-vscode
        ]
        ++ lib.lists.optional cfg.useBlack
        open-vsx.ms-python.black-formatter;
    };
    home.shellAliases.code = "codium";

    home.packages = [
      pkgs.ast-grep
    ];

    xdg.mimeApps.associations.added = {
      "text/x-tex" = "codium.desktop";
      "x-scheme-handler/vscodium" = "codium.desktop";
      "x-scheme-handler/vscode" = "codium.desktop";
    };

    home.file.".config/electron-flags.conf" = lib.mkIf config.booq.gui.sway.enable {
      text = ''
        --enable-features=WaylandWindowDecorations
        --ozone-platform-hint=auto
      '';
    };
  };
}

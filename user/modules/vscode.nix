{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.booq.gui.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      userSettings = {
        "[nix]"."editor.tabSize" = 2;
        "files.insertFinalNewline" = true;
        "editor.acceptSuggestionOnEnter" = "off";
        "editor.fontFamily" = "'FuraCode Mono Nerd Font', 'monospace', monospace";
        "workbench.colorTheme" = "Default Dark+";
        "[python]" = {
          "editor.defaultFormatter" = "ms-python.black-formatter"; # needs extension to be present
          "editor.formatOnSave" = true;
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
      extensions = with pkgs; [
        vscode-extensions.yzhang.markdown-all-in-one
        vscode-extensions.jnoortheen.nix-ide
        vscode-extensions.ms-python.python
        vscode-extensions.hashicorp.terraform
        vscode-extensions.ms-azuretools.vscode-docker
        vscode-extensions.james-yu.latex-workshop
        vscode-extensions.ms-ceintl.vscode-language-pack-de
        vscode-extensions.redhat.vscode-yaml
        open-vsx.codeium.codeium
        open-vsx.ms-python.black-formatter
        open-vsx.zardoy.fix-all-json
        open-vsx.hirse.vscode-ungit
        open-vsx.ipedrazas.kubernetes-snippets
        open-vsx.tumido.crd-snippets
        vscode-marketplace.ast-grep.ast-grep-vscode
      ];
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

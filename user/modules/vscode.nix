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
      };
      keybindings = [
        {
          key = "alt+t";
          command = "go.test.cursor";
        }
      ];
      extensions = with pkgs.vscode-extensions; [
        yzhang.markdown-all-in-one
        jnoortheen.nix-ide
        ms-python.python
        hashicorp.terraform
        ms-azuretools.vscode-docker
        james-yu.latex-workshop
        ms-ceintl.vscode-language-pack-de
        redhat.vscode-yaml
        # TODO: Request or package these extensions:
        # ms-python.black-formatter
        # zardoy.fix-all-json
        # hirse.vscode-ungit
        # ipedrazas.kubernetes-snippets
        # tumido.crd-snippets
      ];
    };
    programs.zsh.shellAliases.code = "codium";

    home.file.".config/electron-flags.conf" = lib.mkIf config.booq.gui.sway.enable {
      text = ''
        --enable-features=WaylandWindowDecorations
        --ozone-platform-hint=auto
      '';
    };
  };
}

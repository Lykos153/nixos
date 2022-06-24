{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    userSettings = {
      "[nix]"."editor.tabSize" = 2;
      "files.insertFinalNewline" = true;
      "editor.acceptSuggestionOnEnter" = "off";
      "workbench.colorTheme" = "Default Dark+";
    };
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
      # zardoy.fix-all-json
      # hirse.vscode-ungit
      # ipedrazas.kubernetes-snippets
      # tumido.crd-snippets
    ];
  };
  programs.zsh.shellAliases.code = "codium";
}

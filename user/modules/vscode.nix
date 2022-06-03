{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    userSettings = {
      "[nix]"."editor.tabSize" = 2;
      "files.insertFinalNewline" = true;
      "editor.acceptSuggestionOnEnter" = "off";
    };
    extensions = with pkgs.vscode-extensions; [
      yzhang.markdown-all-in-one
      jnoortheen.nix-ide
      ms-python.python
      hashicorp.terraform
      ms-azuretools.vscode-docker
      james-yu.latex-workshop
      ms-ceintl.vscode-language-pack-de
    ];
  };
  programs.zsh.shellAliases.code = "codium";
}

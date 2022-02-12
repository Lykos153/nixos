{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    userSettings = {
      "[nix]"."editor.tabSize" = 2;
      "files.insertFinalNewline" = true;
    };
    extensions = with pkgs.vscode-extensions; [
      yzhang.markdown-all-in-one
      jnoortheen.nix-ide
      ms-python.python
      hashicorp.terraform
      ms-azuretools.vscode-docker
      james-yu.latex-workshop
    ];
  };
  programs.zsh.shellAliases.code = "codium";
}

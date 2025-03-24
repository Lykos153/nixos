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
          normal =
            {
              Z = {
                Q = ":quit!";
                Z = ":x";
              };
            }
            // (lib.optionalAttrs config.programs.lazygit.enable {
              C-g = [
                ":write-all"
                ":new"
                ":insert-output lazygit"
                ":buffer-close!"
                ":redraw"
                ":reload-all"
              ];
            });
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

    # # workaround because defaultEditor doesnt seem to work in xorg https://github.com/nix-community/home-manager/issues/1011#issuecomment-1365065753
    # programs.zsh.initExtra = ''
    #   export EDITOR="hx"
    # '';
  };
}

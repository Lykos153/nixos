{ config, lib, nixosConfig, pkgs, ... }:
let
  colorscheme = import ./colors.nix;
in
{
  wayland.windowManager.sway.config = {
      colors = {
        focused = {
          border = "#${colorscheme.leila.fg_0}";
          background = "#${colorscheme.leila.fg_0}";
          text = "#${colorscheme.leila.fg_1}";
          indicator = "#${colorscheme.leila.fg_0}";
          childBorder = "#${colorscheme.leila.fg_0}";
        };
        focusedInactive = {
          border = "#${colorscheme.leila.bg_1}";
          background = "#${colorscheme.leila.bg_1}";
          text = "#${colorscheme.leila.fg_0}";
          indicator = "#${colorscheme.leila.bg_1}";
          childBorder = "#${colorscheme.leila.bg_1}";
        };
        unfocused = {
          border = "#${colorscheme.leila.bg_0}";
          background = "#${colorscheme.leila.bg_0}";
          text = "#${colorscheme.leila.dim_0}";
          indicator = "#${colorscheme.leila.bg_0}";
          childBorder = "#${colorscheme.leila.bg_0}";
        };
        urgent = {
          border = "#${colorscheme.leila.red}";
          background = "#${colorscheme.leila.red}";
          text = "#${colorscheme.leila.fg_1}";
          indicator = "#${colorscheme.leila.red}";
          childBorder = "#${colorscheme.leila.red}";
        };
      };
  };
}

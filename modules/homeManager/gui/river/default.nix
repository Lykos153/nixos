{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.booq.gui.river;
in {
  options.booq.gui.river.enable = lib.mkEnableOption "river";
  config = lib.mkIf cfg.enable {
    wayland.windowManager.river = {
      enable = true;
      settings = {
        border-width = 2;
        declare-mode = [
          "locked"
          "normal"
          "passthrough"
        ];
        map = {
          normal =
            {
              "Super Return" = "spawn ${pkgs.foot}/bin/foot";
              "Super+Shift Q" = "close";
              "Super+Shift E" = "exit";
              "Super J" = "focus-view next";
              "Super K" = "focus-view previous";
              "Super+Shift J" = "swap next";
              "Super+Shift K" = "swap previous";
              "Super Period" = "focus-output next";
              "Super Comma" = "focus-output previous";
              "Super+Shift Period" = "send-to-output next";
              "Super+Shift Comma" = "send-to-output previous";
              "Super+Shift Return" = "zoom";
              "Super H" = "send-layout-cmd rivertile \" main-ratio - 0.05 \"";
              "Super L" = "send-layout-cmd rivertile \" main-ratio + 0.05 \"";
              "Super+Shift H" = "send-layout-cmd rivertile \" main-count + 1 \"";
              "Super+Shift L" = "send-layout-cmd rivertile \" main-count - 1 \"";
              "Super+Alt H" = "move left 100";
              "Super+Alt J" = "move down 100";
              "Super+Alt K" = "move up 100";
              "Super+Alt L" = "move right 100";
              "Super+Alt+Control H" = "snap left";
              "Super+Alt+Control J" = "snap down";
              "Super+Alt+Control K" = "snap up";
              "Super+Alt+Control L" = "snap right";
              "Super+Alt+Shift H" = "resize horizontal -100";
              "Super+Alt+Shift J" = "resize vertical 100";
              "Super+Alt+Shift K" = "resize vertical -100";
              "Super+Alt+Shift L" = "resize horizontal 100";
              # pointer normal Super BTN_LEFT move-view
              # pointer normal Super BTN_RIGHT resize-view
              # pointer normal Super BTN_MIDDLE toggle-float

              # riverctl map normal Super 0 set-focused-tags $all_tags
              # riverctl map normal Super+Shift 0 set-view-tags $all_tags

              "Super Space" = "toggle-float";
              "Super F" = "toggle-fullscreen";
              "Super Up" = "send-layout-cmd rivertile \"main-location top\"";
              "Super Right" = "send-layout-cmd rivertile \"main-location right\"";
              "Super Down" = " send-layout-cmd rivertile \"main-location bottom\"";
              "Super Left" = " send-layout-cmd rivertile \"main-location left\"";
              "Super F11" = "enter-mode passthrough";
            }
            // builtins.foldl' (acc: i: let
              tag = builtins.toString (i - 1);
              I = builtins.toString i;
            in
              acc
              // {
                "Super ${I}" = "set-focused-tags ${tag}";
                "Super+Shift ${I}" = "set-view-tags ${tag}";
                "Super+Control ${I}" = "toggle-focused-tags ${tag}";
                "Super+Shift+Control ${I}" = "toggle-view-tags ${tag}";
              }) {}
            (lib.lists.range 1 9);

          passthrough."Super F11" = "enter-mode normal";
        };
      };
      extraConfig = ''
        riverctl spawn ${pkgs.wideriver}/bin/wideriver
        riverctl output-layout wideriver
      '';
    };
  };
}

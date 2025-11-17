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
    booq.gui.wayland.enable = true;
    home.packages = with pkgs; [
      river-ultitile
    ];
    wayland.windowManager.river = {
      enable = true;
      settings = {
        border-width = 2;
        declare-mode = [
          "locked"
          "normal"
          "passthrough"
        ];
        focus-follows-cursor = "always";
        set-cursor-warp = "on-focus-change";
        map = let
          menu = pkgs.writeScript "menu" "${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop --usage-log=$HOME/.cache/j4-dmenu-desktop.log --dmenu=\"${pkgs.dmenu-wayland}/bin/dmenu-wl -i -nb '#002b36' -nf '#839496' -sb '#859900' -sf '#073642'\"";
        in {
          normal =
            {
              "Super Return" = "spawn ${pkgs.foot}/bin/foot";
              "Super D" = "spawn ${menu}";
              "Super+Shift Q" = "close";
              "Super+Shift E" = "exit";
              "Super J" = "focus-view next";
              "Super Tab" = "focus-view next";
              "Super K" = "focus-view previous";
              "Super+Shift Tab" = "focus-view previous";
              "Super+Shift J" = "swap next";
              "Super+Shift K" = "swap previous";
              "Super Period" = "focus-output next";
              "Super Comma" = "focus-output previous";
              "Super+Shift Period" = "send-to-output -current-tags next";
              "Super+Shift Comma" = "send-to-output -current-tags previous";
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
              # riverctl map normal Super 0 set-focused-tags $all_tags
              # riverctl map normal Super+Shift 0 set-view-tags $all_tags

              "Super+Shift Space" = "toggle-float";
              "Super F" = "toggle-fullscreen";
              "Super F11" = "enter-mode passthrough";

              "Super A" = "zoom";
              # Rest of river configuration...

              # These keybinds work with the default river-ultitile layouts
              # Increase/decrease the main size
              "Super U" = "send-layout-cmd river-ultitile \"set integer main-size += 4\"";
              "Super I" = "send-layout-cmd river-ultitile \"set integer main-size -= 4\"";

              # Decrease/increase the main size if it is in the center (on widescreens) and
              # there are no views to the left or right
              "Super+Shift U" = "send-layout-cmd river-ultitile \"set integer main-size-if-only-centered-main += 4\"";
              "Super+Shift I" = "send-layout-cmd river-ultitile \"set integer main-size-if-only-centered-main -= 4\"";

              # Decrease/increase the main count
              "Super N" = "send-layout-cmd river-ultitile \"set integer main-count += 1\"";
              "Super M" = "send-layout-cmd river-ultitile \"set integer main-count -= 1\"";

              # Change layout
              "Super Up   " = "send-layout-cmd river-ultitile \"set string layout = vstack\"";
              "Super Right" = "send-layout-cmd river-ultitile \"set string layout = hstack\"";
              "Super Down " = "send-layout-cmd river-ultitile \"set string layout = monocle\"";
              "Super Left " = "send-layout-cmd river-ultitile \"set string layout = main\"";

              # Cycle through layouts on all tags/outputs
              "Super Space" = "send-layout-cmd river-ultitile 'set string layout @ main hstack vstack'";
            }
            // builtins.foldl' (acc: i: let
              pow = n: exp:
                assert exp >= 0;
                  if exp == 0
                  then 1
                  else if exp == 1
                  then n
                  else (pow n (exp - 1)) * n;
              i' =
                if i == 0
                then 10
                else i;
              tag = builtins.toString (pow 2 (i' - 1));
              I = builtins.toString i;
            in
              acc
              // {
                "Super ${I}" = "set-focused-tags ${tag}";
                "Super+Shift ${I}" = "set-view-tags ${tag}";
                "Super+Control ${I}" = "toggle-focused-tags ${tag}";
                "Super+Shift+Control ${I}" = "toggle-view-tags ${tag}";
              }) {}
            (lib.lists.range 0 9);

          passthrough."Super F11" = "enter-mode normal";
        };
      };
      extraConfig = ''
        riverctl spawn river-ultitile
        riverctl spawn waybar
        riverctl default-layout river-ultitile

        riverctl keyboard-layout de # alternatively XKB_* variables
        # TODO: how to set layouts per-input? https://codeberg.org/river/river/issues/400

        riverctl map-pointer normal Super BTN_LEFT move-view
        riverctl map-pointer normal Super BTN_RIGHT resize-view
        riverctl map-pointer normal Super BTN_MIDDLE toggle-float
      '';
    };
  };
}

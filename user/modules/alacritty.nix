{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.booq.gui.enable {
    wayland.windowManager.sway.config = lib.mkIf config.booq.gui.sway.enable {
      terminal = "alacritty";
    };

    programs.alacritty = {
      enable = true;
      settings = {
        keyboard.bindings = [
          {
            mods = "Control|Shift";
            key = "Return";
            action = "SpawnNewInstance";
          }
        ];
        env = {
          TERM = "xterm-256color";
        };
      };
    };
  };
}

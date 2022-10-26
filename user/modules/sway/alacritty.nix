{
  # TODO: if sway is enabled
  wayland.windowManager.sway.config.terminal = "alacritty";

  programs.alacritty = {
    enable = true;
    settings = {
      key_bindings = [
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
}

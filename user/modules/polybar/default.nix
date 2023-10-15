{
  config,
  pkgs,
  lib,
  ...
}: let
  mainBar = builtins.readFile ./bar.ini;
  pulseaudio-control = "${pkgs.lykos153.polybar-pulseaudio-control}/bin/pulseaudio-control";
  pulseaudioModule = ''
    [module/pulseaudio-control-output]
      type = custom/script
      tail = true
      format-underline = $${colors.cyan}
      label-padding = 2
      label-foreground = $${colors.foreground}

      # Icons mixed from Font Awesome 5 and Material Icons
      # You can copy-paste your options for each possible action, which is more
      # trouble-free but repetitive, or apply only the relevant ones (for example
      # --node-blacklist is only needed for next-node).
      exec = ${pulseaudio-control} --icons-volume " , " --icon-muted " " --node-nicknames-from "device.description" --node-nickname "alsa_output.pci-0000_00_1f.3.analog-stereo:  Intern" --node-blacklist "easyeffects_sink" listen
      click-right = exec ${pkgs.pavucontrol}/bin/pavucontrol &
      click-left = ${pulseaudio-control} togmute
      click-middle = ${pulseaudio-control} --node-blacklist "easyeffects_sink" next-node
      scroll-up = ${pulseaudio-control} --volume-max 130 up
      scroll-down = ${pulseaudio-control} --volume-max 130 down

      [module/pulseaudio-control-input]
      type = custom/script
      tail = true
      format-underline = $${colors.cyan}
      label-padding = 2
      label-foreground = $${colors.foreground}

      # Use --node-blacklist to remove the unwanted PulseAudio .monitor that are child of sinks
      exec = ${pulseaudio-control}  --node-type input --icons-volume "" --icon-muted "" --node-nicknames-from "device.description" --node-nickname "alsa_input.pci-0000_00_1f.3.analog-stereo:  Intern" --node-blacklist "*.monitor" --node-blacklist "easyeffects_source" listen
      click-right = exec ${pkgs.pavucontrol}/bin/pavucontrol &
      click-left = ${pulseaudio-control} --node-type input togmute
      click-middle = ${pulseaudio-control} --node-type input next-node
      scroll-up = ${pulseaudio-control} --node-type input --volume-max 130 up
      scroll-down = ${pulseaudio-control} --node-type input --volume-max 130 down
  '';
in
  lib.mkIf (config.booq.gui.enable && config.booq.gui.xorg.enable) {
    services.polybar = {
      enable = true;
      package = pkgs.polybar.override {
        pulseSupport = true;
      };
      config = ./config.ini;
      extraConfig = mainBar + pulseaudioModule;
      script = ''
        for m in $(polybar --list-monitors | ${pkgs.coreutils}/bin/cut -d":" -f1); do
          MONITOR=$m polybar --reload main & disown
        done
      '';
    };
  }

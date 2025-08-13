{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.booq.audio;
in {
  options.booq.audio = {
    enable = lib.mkEnableOption "audio";
    backend = lib.mkOption {
      default = "pulseaudio";
      type = lib.types.enum ["pulseaudio" "pipewire"];
    };
  };
  config =
    lib.mkIf (cfg.enable && cfg.backend == "pipewire") {
      security.rtkit.enable = true;
      hardware.pulseaudio.enable = false;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        # Some useful knobs if you want to finetune or debug your setup:
        # NOTE: Arrays are replaced rather than merged with defaults,
        # so in order to keep any default items in the configuration,
        # they HAVE to be listed.
        # config.pipewire = {
        #   "context.properties" = {
        #     "link.max-buffers" = 64;
        #     "link.max-buffers" = 16; # version < 3 clients can't handle more than this
        #     "log.level" = 2; # https://docs.pipewire.org/page_daemon.html
        #     "default.clock.rate" = 48000;
        #     "default.clock.quantum" = 1024;
        #     "default.clock.min-quantum" = 32;
        #     "default.clock.max-quantum" = 8192;
        # };
      };
      wireplumber.enable = true;
      wireplumber.extraConfig.bluetoothEnhancements = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = ["hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"];
        };
      };
      xdg.portal.wlr.enable = true;
    }
    // lib.mkIf (cfg.enable && cfg.backend == "pulseaudio") {
      services.pipewire.enable = false;
      hardware.pulseaudio = {
        enable = true;
        package = pkgs.pulseaudioFull;
      };
    };
}

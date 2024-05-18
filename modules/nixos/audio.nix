{
  config,
  lib,
  pkgs,
  ...
}: {
  options.booq.audio = lib.mkOption {
    default = "pulseaudio";
    type = lib.types.str;
  };
  config =
    lib.mkIf (config.booq.audio == "pipewire") {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
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
      xdg.portal.wlr.enable = true;
    }
    // lib.mkIf (config.booq.audio == "pulseaudio") {
      sound.enable = true;
      hardware.pulseaudio.enable = true;
    };
}

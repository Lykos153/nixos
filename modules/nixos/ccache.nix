{
  lib,
  config,
  ...
}: let
  cfg = config.booq.ccache;
in {
  options.booq.ccache.enable = lib.mkEnableOption "ccache";
  config = lib.mkIf cfg.enable {
    programs.ccache.enable = true;
    programs.ccache.packageNames = ["linux_bcachefs"];
    nix.settings.extra-sandbox-paths = [config.programs.ccache.cacheDir];
    environment.persistence."${config.booq.impermanence.persistRoot}".directories = [config.programs.ccache.cacheDir];
    nixpkgs.overlays = [
      (self: super: {
        ccacheWrapper = super.ccacheWrapper.override {
          extraConfig = ''
            export CCACHE_COMPRESS=1
            export CCACHE_DIR="${config.programs.ccache.cacheDir}"
            export CCACHE_UMASK=007
            if [ ! -d "$CCACHE_DIR" ]; then
              echo "====="
              echo "Directory '$CCACHE_DIR' does not exist"
              echo "Please create it with:"
              echo "  sudo mkdir -m0770 '$CCACHE_DIR'"
              echo "  sudo chown root:nixbld '$CCACHE_DIR'"
              echo "====="
              exit 1
            fi
            if [ ! -w "$CCACHE_DIR" ]; then
              echo "====="
              echo "Directory '$CCACHE_DIR' is not accessible for user $(whoami)"
              echo "Please verify its access permissions"
              echo "====="
              exit 1
            fi
          '';
        };
      })
    ];
  };
}

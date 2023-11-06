{
  lib,
  pkgs,
  config,
  ...
}: {
  nixpkgs.allowUnfreePackages = [
    "nvidia-.*"
  ];

  nixpkgs.config.cudaSupport = true;

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      sync.enable = true;

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };

    vgpu = {
      enable = true; # Enable NVIDIA KVM vGPU + GRID driver
      unlock.enable = true; # Unlock vGPU functionality on consumer cards using DualCoder/vgpu_unlock project.
    };
  };

  # CUDA
  # boot.kernelModules = [ "nvidia-uvm" ];
  # boot.blacklistedKernelModules = [ "nouveau" ];

  nix = {
    settings = {
      substituters = [
        "https://cuda-maintainers.cachix.org"
      ];
      trusted-public-keys = [
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];
    };
  };
  # TODO: check out https://github.com/guibou/nixGL
}

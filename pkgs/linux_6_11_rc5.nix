{
  fetchurl,
  buildLinux,
  ...
} @ args:
buildLinux (args
  // rec {
    version = "6.11.0-rc5";
    modDirVersion = version;

    src = fetchurl {
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/snapshot/linux-6.11-rc5.tar.gz";
      hash = "sha256-SKEkiHR+5JTDEvtZz48HCnscDaHqpWO1WINeIAM5SZk=";
    };
    kernelPatches = [];

    extraConfig = ''
    '';

    extraMeta.branch = "6.11";
  }
  // (args.argsOverride or {}))

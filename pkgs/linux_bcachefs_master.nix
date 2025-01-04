{
  lib,
  fetchurl,
  linux_testing,
  src,
  ccacheStdenv,
  ...
} @ args:
linux_testing.override {
  stdenv = ccacheStdenv;
  argsOverride = rec {
    inherit src;
    version = "6.13-custom-bcachefs";
    modDirVersion = "6.13.0-rc3";
  };
}

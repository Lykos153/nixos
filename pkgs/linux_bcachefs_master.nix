{
  lib,
  fetchurl,
  linux_testing,
  src,
  ...
} @ args:
linux_testing.override {
  argsOverride = rec {
    inherit src;
    version = "6.12-custom-bcachefs";
    modDirVersion = "6.12.0-rc6";
  };
}

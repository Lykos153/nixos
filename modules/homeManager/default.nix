{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; {
  imports =
    (map (n: "${./.}/${n}") (filter (n: n != "default.nix") (attrNames (readDir ./.))))
    ++ [
      ../common
    ];
}

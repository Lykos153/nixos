{pkgs, ...}: {
  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    openFirewall = true;
    secretKeyFile = "/root/secrets/nix-serve.key";
  };
}

{ config, home, lib, ... }:
{
  sops.secrets.mrconfig = {
    sopsFile = ./secrets/mrconfig;
    format = "binary";
  };
  # TODO: create module that maybe spawns a service after sops. then i can use it generically for all users. why isnt this built into sops-nix?
  home.activation.linkMrconfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    "$DRY_RUN_CMD" ln "$VERBOSE_ARG" -sf "$XDG_RUNTIME_DIR/secrets/mrconfig" "$HOME/.mrconfig"
  '';
}

{lib}: rec {
  mkModules = {
    nixpkgs,
    username,
    hostname,
    userdir,
    modules ? [],
  }: let
    userpath = "${userdir}/${username}";
    hostpath = "${userpath}/${hostname}";

    usermodules =
      if builtins.pathExists userpath
      then [userpath]
      else [];
    hostmodules =
      if builtins.pathExists hostpath
      then [hostpath]
      else [];
  in (
    [
      {
        home.sessionVariables.NIX_PATH = "nixpkgs=${nixpkgs}";
        # workaround because the above doesnt seem to work in xorg https://github.com/nix-community/home-manager/issues/1011#issuecomment-1365065753
        programs.zsh.initContent = ''
          export NIX_PATH="nixpkgs=${nixpkgs}"
        '';
      }
    ]
    ++ modules
    ++ usermodules
    ++ hostmodules
  );
}

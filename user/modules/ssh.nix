{
  programs.ssh = {
    enable = true;
    compression = true;
    forwardAgent = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
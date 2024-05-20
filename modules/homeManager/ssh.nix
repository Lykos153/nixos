{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.booq.ssh;
in {
  options.booq.ssh = {
    enable = lib.mkEnableOption "ssh";
  };
  config = let
    knownHostsCommon = ".ssh/known_hosts_common";
  in
    lib.mkIf cfg.enable {
      programs.ssh = {
        enable = true;
        compression = true;
        forwardAgent = false;
        extraConfig = ''
          AddKeysToAgent yes
        '';
        includes = ["local.d/*" "config.d/*"];
        userKnownHostsFile = "~/.ssh/known_hosts ~/${knownHostsCommon}";
      };
      home.packages = with pkgs; [
        mosh
      ];
      home.file."${knownHostsCommon}".text = ''
        gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf
        github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
        github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
        github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
        gitlab.cloudandheat.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRGx0orGa+te5B3Iz0j29vBSuGMolNkT4d9xzgUulSd
        # codeberg.org:22 SSH-2.0-OpenSSH_7.9p1 Debian-10+deb10u1
        codeberg.org ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBL2pDxWr18SoiDJCGZ5LmxPygTlPu+cCKSkpqkvCyQzl5xmIMeKNdfdBpfbCGDPoZQghePzFZkKJNR/v9Win3Sc=
        # codeberg.org:22 SSH-2.0-OpenSSH_7.9p1 Debian-10+deb10u1
        codeberg.org ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8hZi7K1/2E2uBX8gwPRJAHvRAob+3Sn+y2hxiEhN0buv1igjYFTgFO2qQD8vLfU/HT/P/rqvEeTvaDfY1y/vcvQ8+YuUYyTwE2UaVU5aJv89y6PEZBYycaJCPdGIfZlLMmjilh/Sk8IWSEK6dQr+g686lu5cSWrFW60ixWpHpEVB26eRWin3lKYWSQGMwwKv4LwmW3ouqqs4Z4vsqRFqXJ/eCi3yhpT+nOjljXvZKiYTpYajqUC48IHAxTWugrKe1vXWOPxVXXMQEPsaIRc2hpK+v1LmfB7GnEGvF1UAKnEZbUuiD9PBEeD5a1MZQIzcoPWCrTxipEpuXQ5Tni4mN
        # codeberg.org:22 SSH-2.0-OpenSSH_7.9p1 Debian-10+deb10u1
        codeberg.org ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIVIC02vnjFyL+I4RHfvIGNtOgJMe769VTF1VR4EB3ZB
        nbg.booq.org ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEfw3oGP02QzdWzxdn/ONiDKNT1djmuwrLp1UshPkwjMHzgvjzSGqXeCyJAmVPbEP6KW1IBo4GBFYIMlc2op1Yg=
        nbg.booq.org ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuyiHStx2A+9LSm+EAJiXMLFEsRU/2kj9bvqlWgxAZ/eSDwp5XRbkWnOSq5pB+e9q/DKP97blacyLkSF8AHPqIrV5i+bNeqsGRL5e9IE9iVURfDwGJwzBupxOF36PbygY1oNzyAafMswBhplIngiQUZtRWoVvD/MxcyvXSBqqGiPkLMMDTvRCTll7Y4wvNg97CXtyw4dvqbT74k7ySkDxq7dHtmz+0Ta1S6R2yqpRwbxOAleQj95SIRcGkKnTqT23mMH/7Za+ZvRstvqegk0ekt7ECaAlrHwJ4riYTzc7suBccQKO4oJtD01r52IShnd/sKI293uLgORRJ5W0Uij9j
        nbg.booq.org ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILMFSSnlNwf6+Jzu16enUaINi3mwW9Z1wDkMBH3VD5lN
        [nbg.booq.org]:2222 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILO4DCAWXdNLoOM6K726+cYOlZIeg22DaDxYqR5newho
        @cert-authority [nbg.booq.org]:2222,[116.203.149.88]:2222 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILO4DCAWXdNLoOM6K726+cYOlZIeg22DaDxYqR5newho
      '';
    };
}

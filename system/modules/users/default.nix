{
  pkgs,
  config,
  ...
}: {
  imports = [./sops.nix];

  users.users.silvio = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.nushell;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDoHum4oCBnA8D9EXORuM6I8ARALZ6uEDF0zIBu1+V7RW1zNBlhlC8m+ZZ23NxridfVkUat6Nh6EfsJXTzzsKwERayrTULCp7YWm5ALO8vFUKM5qRyCoiLR5E9WpVYeNVLkYXjiIl4ctcotVJ65zxLAdeIi6QYJHd4Ze8lhzO5bqOQSNYVzMj+ASmY6/886IRwCYVM+dJ7sMSMN6suk4mgVSRR3+L5D2+zrYRkhfT/cD6aCdkHOZLV+mW3W79D7v+6Vba2zxZiH2UlAfTuQbkEKSQbB4Sy9uruKfv4gFOx+mxrK1rdWE0peMzCcEFeEEN5Fkh3Riy91xNRK2gnvsLqRYE7wLxaH7+X9zTMJYZDuGGgMU+3E1IfowOqA7w10YmSHIpCNEFkUb/FPaGCpEtLBgRwq/kYmCwghWmcp6MOQ83p6hwTqZ8fvgkdvtd7UIbha87WlEAhy0fHS6dLdPc0H66OlBDscsJkM4qmntiBnzFxInvZfyVnAWjNcNxSDmTpv1FdAPfquItY1PNhZSea1elFC3k6ivYUwe8n83dgJKb1ODU0D//ScsLiQiSvD4yjqx3cLj2NLEJ7QA+LQpT6APLDAJQM/AHmbqpi+m95aprtSRR1FH6LB8aX7Icgb4lHiE3QwwsLdPnn0TIWyQXgaoO0bNVPjELXoAyibQpHTBw=="
    ];
  };

  users.users.sa = {
    uid = 1003;
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.nushell;
  };

  users.users.mine = {
    uid = 1001;
    isNormalUser = true;
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  users.users.leila = {
    uid = 1002;
    isNormalUser = true;
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  users.users.root.shell = pkgs.zsh;
}

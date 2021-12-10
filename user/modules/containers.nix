{pkgs, ... }:
{
    home.packages = with pkgs; [
        x11docker
    ];
}
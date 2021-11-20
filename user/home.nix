{ config, pkgs, ... }:

let
  editor = "vim";
in
{
  imports = [ ./vim.nix ./zsh.nix ./mail.nix ];

  home.username = "silvio";
  home.homeDirectory = "/home/silvio";
  
  home.stateVersion = "21.05";

  programs.home-manager.enable = true;
  programs.firefox.enable = true;
  programs.direnv.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "dmenu_run";

      left = "j";
      right = "odiaeresis";
      up = "l";
      down = "k";

      input = {
        "*" = {
          xkb_layout = "de";
        };
      };
    };
      extraConfig = ''
        bindsym Mod4+Escape exec swaylock -c000000
        bindsym Pause exec swaylock -c000000
      '';
  };

  programs.git = {
    enable = true;
    userEmail = "silvio@booq.org";
    userName = "Silvio Ankermann";
    aliases = {
      graph = "log --all --oneline --graph --decorate";
    };
    extraConfig = {
      push = {
        default = "simple";
        followtags  = true;
      };
      pull = {
        ff = "only";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.gpg.enable = true;

  programs.ssh = {
    enable = true;
    compression = true;
    forwardAgent = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };

  programs.bat = {
    enable = true;
    config = {
      tabs = "4";
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      yzhang.markdown-all-in-one
    ];
  };

  home.packages = with pkgs; [
    swaylock
    swayidle
    wl-clipboard
    mako
    alacritty
    dmenu
    vimPlugins.vim-plug
    wdisplays
    j4-dmenu-desktop
    termite
    vifm
    pass
    git
    kanshi
    grim
    slurp
    light
    i3status
    clipman
    gajim
    htop
  ];

  
  services.gpg-agent = {
    enable = true;

    defaultCacheTtl = 86400;
    defaultCacheTtlSsh = 86400;
    maxCacheTtl = 86400;
    maxCacheTtlSsh = 86400;
    enableSshSupport = true;
    extraConfig = ''
      pinentry-program ${pkgs.pinentry-qt}/bin/pinentry
    '' + ''
      allow-loopback-pinentry
    '';
  };

  
  services.redshift = {
    enable = true;
    package = pkgs.redshift-wlr;
    provider = "geoclue2";
    temperature.night = 3000;
    temperature.day = 5000;
  };

}

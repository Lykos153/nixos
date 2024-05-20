{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.booq.taskwarrior;
in {
  options.booq.taskwarrior = {
    enable = lib.mkEnableOption "taskwarrior";
  };
  config = lib.mkIf cfg.enable {
    programs.taskwarrior = {
      enable = true;
      colorTheme = "${pkgs.taskwarrior}/share/doc/task/rc/dark-red-256"; # TODO: connect with stylix
    };
    home.packages = with pkgs; [
      vit
    ];
    home.shellAliases.ta = "task";
    home.file."${config.programs.taskwarrior.dataLocation}/hooks/on-modify.timewarrior".source = "${pkgs.lykos153.task-timewarrior-hook}/bin/on-modify.timewarrior";
  };
}

{
  pkgs,
  config,
  ...
}: {
  programs.taskwarrior = {
    enable = true;
  };
  home.packages = with pkgs; [
    vit
  ];
  home.shellAliases.ta = "task";
  home.file."${config.programs.taskwarrior.dataLocation}/hooks/on-modify.timewarrior".source = "${pkgs.lykos153.task-timewarrior-hook}/bin/on-modify.timewarrior";
}

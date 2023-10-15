{
  config,
  home,
  ...
}: {
  home.file."garden.yaml".source = ./garden.yaml;
}

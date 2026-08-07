{
  services.kubo.enable = true;
  users.users.silvio = {
    extraGroups = ["ipfs"];
  };
  users.users.sa = {
    extraGroups = ["ipfs"];
  };
}

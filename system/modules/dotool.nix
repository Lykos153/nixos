{
  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
  '';
  users.users.silvio = {
    extraGroups = [
      "input"
    ];
  };
  #TODO: dont repeat
  users.users.sa = {
    extraGroups = [
      "input"
    ];
  };
}

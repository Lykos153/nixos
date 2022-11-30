{
  # TODO: make de_menu_to_super a variable?
  home.file.".xkb/symbols/de_menu_to_super".text = ''
    xkb_symbols "basic" {
      include "de"
      key <MENU> { [ Super_R ] };
    };
  '';
}

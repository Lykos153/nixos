{
  home.file.".xkb/symbols/de_menu_to_super".text = ''
    xkb_symbols "basic" {
      include "de"
      key <MENU> { [ Super_R ] };
    };
  '';
  home.file.".xkb/symbols/de_print_to_super".text = ''
    xkb_symbols "basic" {
      include "de"
      key <PRSC> { [ Super_R ] };
    };
  '';
}

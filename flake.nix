{
  description = "A collection of flake templates";

  inputs = {
    direnv.url = "github:nix-community/nix-direnv";
  };

  outputs = { self, direnv }: {

    templates = {
      # TODO: Check what https://github.com/jonringer/nix-template does
      pythonenv = {
        path = ./templates/pythonenv;
        description = "Flake to setup python virtualenv with direnv";
      };

      direnv = direnv.defaultTemplate;

    };
  };
}

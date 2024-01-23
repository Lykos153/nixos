#!/usr/bin/env nu
def main [user?: string] {
  let user = if ($user != null) { $user } else { id -un | str trim }
  print $"Building and pushing user environment for ($user)..."
  nix build $"($env.FILE_PWD)#homeConfigurations.($user).activationPackage" | cachix push lykos153
}

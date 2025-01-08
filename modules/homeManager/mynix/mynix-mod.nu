def complete_mynix_action [context: string] {
  print $context
  {
    system: [build switch test boot]
    user: [build switch]
  } | get -i ($context | split words).1
}

def complete_mynix_target [] {
  [user system upgrade]
}

export def mynix [ target:string@complete_mynix_target, action?:string@complete_mynix_action, --flake: string = "/etc/nixos" ] {
  match $target {
    "system" => (sudo nixos-rebuild $action --flake $"($flake)#(hostname)")
    "user" => (home-manager $action -b $"bak.(date now | format date "%s")" --flake $"($flake)#(id -un)@(hostname)")
    "upgrade" => (upgrade $flake)
  }
}

def nix_prefix_package [package: string] {
  if ($package | find --regex "#|:") == null {
    "nixpkgs#" + $package
  } else {$package}
}

export def nr [ package: string, --unfree, --insecure, ...args: string ] {
  let cmd = (if ($unfree or $insecure) {["--impure"]} else []) ++ [(nix_prefix_package $package)] ++ $args
  with-env {
    NIXPKGS_ALLOW_UNFREE: (if $unfree {"1"} else {"0"}),
    NIXPKGS_ALLOW_INSECURE: (if $insecure {"1"} else {"0"}),
  } { nix run ...$cmd }
}

export def nsh [...args: string, --unfree, --insecure] {
  let cmd = (if ($unfree or $insecure) {["--impure"]} else []) ++ ($args | each {|x| (nix_prefix_package $x)})
  with-env {
    NIXPKGS_ALLOW_UNFREE: (if $unfree {"1"} else {"0"}),
    NIXPKGS_ALLOW_INSECURE: (if $insecure {"1"} else {"0"}),
  } { nix shell ...$cmd }
}

def upgrade-check [flake: string] {
  (git -C $flake status --short . | lines | filter {|x| not ( $x | str contains "flake.lock") } | length) == 0
}

def upgrade [flake: string] {
  if not (upgrade-check $flake) {
    print $"($flake) is dirty"
    return
  }
  nix flake update --flake $flake
  let changed = (do {git -C $flake diff --quiet flake.lock} | complete).exit_code != 0
  if not $changed {
    print "Nothing to do"
    return
  }

  mynix system build --flake $flake
  nvd diff /run/current-system result
  rm result
  git -C $flake commit -m $"Upgrade" flake.lock
}

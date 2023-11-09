def complete_mynix_action [context: string] {
  print $context
  {
    system: [build switch test boot]
    user: [build switch]
  } | get -i ($context | split words).1
}

def complete_mynix_target [] {
  [user system]
}

export def mynix [ target:string@complete_mynix_target, action:string@complete_mynix_action ] {
  match $target {
    "system" => (sudo nixos-rebuild $action --flake $"($env.HOME)/nixos/system#(hostname)")
    "user" => (home-manager $action -b $"bak.(date now | format date "%s")" --flake $"($env.HOME)/nixos/user#(id -un)")
  }
}
export def nr [ package: string, --unfree, ...args: string ] {
  let cmd = (if $unfree {["--impure"]} else []) ++ [$"nixpkgs#($package)"] ++ args
  with-env { NIXPKGS_ALLOW_UNFREE: (if $unfree {"1"} else {"0"})} { nix run $cmd }
}

export def nsh [...args: string, --unfree] {
  let cmd = (if $unfree {["--impure"]} else []) ++ ($args | each {|x| "nixpkgs#" + $x})
  with-env { NIXPKGS_ALLOW_UNFREE: (if $unfree {"1"} else {"0"})} { nix shell $cmd }
}

def upgrade-check [flake: string] {
  (git -C $flake status --short . | lines | filter {|x| not ( $x | str contains "flake.lock") } | length) == 0
}

def complete_upgrade [] {
  ["user" "system"]
}

export def upgrade [target: string@complete_upgrade] {
  let flake = $env.HOME + "/nixos/" + $target
  if not (upgrade-check $flake) {
    print $"($flake) is dirty"
    return
  }
  nix flake update $flake
  let changed = (do {git -C $flake diff --quiet flake.lock} | complete).exit_code != 0
  if not $changed {
    print "Nothing to do"
    return
  }
  mynix $target switch
  git -C $flake commit -m $"Upgrade ($target)" flake.lock
}

export def mynix [ action:string , target:string] {
  match $target {
    "system" => (sudo nixos-rebuild $action --flake $"($env.HOME)/nixos/system#(hostname)")
    "user" => (home-manager $action -b $"bak.(date now | format date "%s")" --flake $"($env.HOME)/nixos/user#(id -un)")
  }
}
export def nr [ package: string, --unfree: bool, ...args: string ] {
  # TODO: unfree, run from github: etc
  nix run $"nixpkgs#($package)" $args
}
export def nsh [...args: string] {
  let args = ($args | each {|x| "nixpkgs#" + $x})
  nix shell $args
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
  mynix switch $target
  git -C $flake commit -m $"Upgrade ($target)" flake.lock
}

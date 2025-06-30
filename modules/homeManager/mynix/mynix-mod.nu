def complete_mynix_action [context: string] {
  print $context
  {
    system: [build switch test boot]
    user: [build switch]
  } | get -i ($context | split words).1
}

export def "mynix system" [action?:string@complete_mynix_action, --flake: string = "/etc/nixos" ] {
    sudo nixos-rebuild $action --flake $"($flake)#(hostname)"
}

export def "mynix user" [action?:string@complete_mynix_action, --flake: string = "/etc/nixos"] {
  home-manager $action -b $"bak.(date now | format date "%s")" --flake $"($flake)#(id -un)@(hostname)"
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
  (git -C $flake status --short . | lines | where {|x| not ( $x | str contains "flake.lock") } | length) == 0
}

def "mynix upgrade" [--flake: string = "/etc/nixos"] {
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

export def "mynix generation list" [] {
  sudo nix-env --list-generations -p /nix/var/nix/profiles/system | parse -r `^\s+(?<gen>[0-9]+)\s+(?<date>[0-9-: ]*)\s*(?<tag>\(current\))?` | upsert date {|i| $i.date | into datetime}
}

def _cmpl_mynix_generation_switch_gen [] {
  sudo nix-env --list-generations -p /nix/var/nix/profiles/system | parse -r `^\s+(?<value>[0-9]+)\s+(?<description>.*)` | reverse
}

export def "mynix generation switch" [gen: int@_cmpl_mynix_generation_switch_gen] {
  sudo nix-env --switch-generation $gen -p /nix/var/nix/profiles/system
  sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
}

export def "mynix generation diff" [gen: int@_cmpl_mynix_generation_switch_gen, gen2?:int@_cmpl_mynix_generation_switch_gen] {
  let system_link = {|gen| $"/nix/var/nix/profiles/system-($gen)-link"}

  let gen2 = if ($gen2 == null) {"/run/current-system"} else {do $system_link $gen2}

  nvd diff (do $system_link $gen) $gen2
}

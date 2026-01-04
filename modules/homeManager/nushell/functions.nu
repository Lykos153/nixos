export def --env cdt [template: string="cdt"] {
  let suffix = ".XXXXX"
  if ($template | str contains "/") {
    mkdir $"/tmp/(dirname $template)"
  }
  let tmpdir = (mktemp -d --tmpdir ($template + $suffix))
  cd $tmpdir
}

export def --env tclone [repo: string] {
  # Derive directory from the repository name
  # Try using "humanish" part of source repo if user didn't specify one
  let dir = (
    if ("$repo" | path exists) {
        # Cloning from a bundle
        $repo | sed -e 's|/*\.bundle$||' -e 's|.*/||g'
    } else {
        $repo | sed -e 's|/$||' -e 's|:*/*\.git$||' -e 's|.*[/:]||g'
    }
  )

  cdt $"tclone-($dir)"
  pwd

  git clone $repo .
}

export def rwhich [application:string, ...rest: string] {
  which $application ...$rest | update path {|row| if $row.path == "" {""} else {(realpath $row.path)} } | upsert expansion {|row| help aliases | where name == $row.command | get expansion | to text} | upsert source {|row| if $row.type == "custom" {(view source ($row.command))} else {""}}
}

export def "from env" []: string -> record {
  lines
    | split column '#'
    | get column1
    | where {($in | str length) > 0}
    | parse "{key}={value}"
    | update value {str trim -c '"'}
    | transpose -r -d
}

export def ll [pattern?: string] {
  ls (if $pattern != null {$pattern} else {"."}) | update size {|row| $row.size | into int} |  update modified {|row| $row.modified | format date "%Y-%m-%d %H:%M:%S"}
}

export def slurp [...args: string] {
  $args | reduce --fold [] {|arg,acc| $acc ++ (glob $arg | each {|file| open $file}) }
}

export def "table-to-record" [primary: string] {
  reduce --fold {} {|it, acc| $acc | insert ($it | get $primary) ($it | reject $primary)}
}

# Recursively search and replace in files
export def rsd [search: string, replace: string] {
  rg -l $search | xargs sd $search $replace
}

# Replace a symlink with a writable copy
export def editify [filename: string] {
  cd ($filename | path dirname)
  let filename = ($filename | path basename)
  let t = ^mktemp -u -p .
  cp $filename $t
  rm $filename
  mv $t $filename
  chmod +w $filename
}

export def wpa_add [ssid: string, --tmp, --nixos_conf_dir: string ="/etc/nixos"] {
  let conf_file = "/etc/wpa_supplicant.conf"
  let secrets_file = $"($nixos_conf_dir)/machines/_common/secrets.yaml"
  let key = "wpa_supplicant.conf"

  let wpa_supplicant_conf = if ($tmp) {
    (sudo cat $conf_file)
  } else {
    (sops -d $secrets_file | from yaml | get $key)
  }

  let pw = (input --suppress-output $"Password for ($ssid): ")
  let new_entry = if ($pw == "") {
$"network={
	ssid=\"($ssid)\"
}"
    } else {
      ($pw | wpa_passphrase $ssid)
    }
  let wpa_supplicant_conf = $"($wpa_supplicant_conf)\n($new_entry)"

  if (not $tmp) {
    {$key: $wpa_supplicant_conf} | to yaml | sops encrypt --filename-override $secrets_file | save -f $secrets_file
  }

  sudo rm $conf_file
  $wpa_supplicant_conf | sudo nu --stdin -c $"save ($conf_file)"
  sudo systemctl restart wpa_supplicant.service
}

# from https://www.nushell.sh/cookbook/foreign_shell_scripts.html#capturing-the-environment-from-a-foreign-shell-script

# Returns a record of changed env variables after running a non-nushell script's contents (passed via stdin), e.g. a bash script you want to "source"
export def capture-foreign-env [
    --shell (-s): string = /bin/sh
    # The shell to run the script in
    # (has to support '-c' argument and POSIX 'env', 'echo', 'eval' commands)
    --arguments (-a): list<string> = []
    # Additional command line arguments to pass to the foreign shell
] {
    let script_contents = $in;
    let env_out = with-env { SCRIPT_TO_SOURCE: $script_contents } {
        ^$shell ...$arguments -c `
        env
        echo '<ENV_CAPTURE_EVAL_FENCE>'
        eval "$SCRIPT_TO_SOURCE"
        echo '<ENV_CAPTURE_EVAL_FENCE>'
        env -0 -u _ -u _AST_FEATURES -u SHLVL` # Filter out known changing variables
    }
    | split row '<ENV_CAPTURE_EVAL_FENCE>'
    | {
        before: ($in | first | str trim | lines)
        after: ($in | last | str trim | split row (char --integer 0))
    }

    # Unfortunate Assumption:
    # No changed env var contains newlines (not cleanly parseable)
    $env_out.after
    | where { |line| $line not-in $env_out.before } # Only get changed lines
    | parse "{key}={value}"
    | transpose --header-row --as-record
    | if $in == [] { {} } else { $in }
    | reject SCRIPT_TO_SOURCE
}

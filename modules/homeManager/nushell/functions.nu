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
    | filter {($in | str length) > 0}
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
def rsd [search: string, replace: string] {
  rg -l $search | xargs sd $search $replace
}

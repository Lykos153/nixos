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
  which $application ...$rest | update path {|row| (realpath $row.path) }
}

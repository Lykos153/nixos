def _cmpl_project [] {
    atl git cat-file blob main:projects | lines
}

def _end_of_last [] {
    (atl ls -O json | complete | get stdout | from json --objects | get fields.end | sort | last | last)
}

def _cmpl_at [] {
    [
        now
        (_end_of_last)
    ]
}

def _cmpl_tag [] {
    atl git annex metadata -j | from json --objects | get fields | filter {|r| "tag" in ($r | columns)} | get tag | reduce {|r,acc| $acc ++ $r } | uniq -c | sort-by -r count | get value
}

export def "atl start" [--at: string@_cmpl_at="now", project: string@_cmpl_project, ...args: string@_cmpl_tag ] {
    atl stop $at; atl track $"start=($at)" $"project=($project)" ...$args
}

export def "atl now" [project: string@_cmpl_project, ...args: string@_cmpl_tag ] {
    atl track $"start=(_end_of_last)" $"project=($project)" ...$args
}

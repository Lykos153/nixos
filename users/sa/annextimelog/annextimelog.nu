export def "atl start" [...args: string ] {
    atl stop; atl track start=now ...$args
}

export def "atl now" [...args: string ] {
    atl track $"start=(atl ls -O json | from json --objects | get fields.end | sort | last | last)" ...$args
}

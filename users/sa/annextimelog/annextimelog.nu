def _get_contracts [] {
    atl git cat-file blob main:contracts.yaml | from yaml
}

def _cmpl_project [] {
    (atl git cat-file blob main:projects.yaml
        | from yaml
        | transpose name details
        | reduce --fold [] {|project,pAcc|
            $pAcc ++ $project.name ++ (
                if (($project.details != null) and ("tasks" in ($project.details))) {
                    $project.details.tasks
                        | reduce --fold [] {|task,tAcc|
                            $tAcc ++ $"($project.name).($task)"
                        }
                } else {[]})
        }
    )
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

export def "atl done" [project: string@_cmpl_project, ...args: string@_cmpl_tag ] {
    atl track $"start=(_end_of_last)" $"project=($project)" end=now ...$args
}

export def "atl cancel" [] {
    atl rm .open
}

export def "atl sum" [...query: string] {
    let query = if ($query == []) {["today"]} else {$query}
    get_records ...$query | get fields.duration | math sum | format duration hr
}

export def "atl away" [day: datetime, reason: string, --until: datetime ...$tags] {
    let hours_per_day = (_get_contracts | sort-by start --reverse | first | get hours-per-week) / 5
    let track_away_day = {|day| atl track $"($day)T10:00" - $"($day)T(10 + $hours_per_day):00" project=abwesenheit $reason ...$tags}
    if ($until != null) {
        generate {|day|
            {
                out: $day,
                next: ($day + 1day),
            }
        } $day
        | filter {not (($in | format date %a) in ["Sun" "Sat" "Sa" "So"]) } # how to ensure english here?
        | take until {$in > $until}
        | each {$in | format date %Y-%m-%d}
        | each {do $track_away_day $in}
    } else {
        do $track_away_day $day
    }

}

def get_start_of_day [] {
    date to-record | $"($in.year)-($in.month)-($in.day)" | into datetime
}

def render_time [] {
    let rec = $in
    let hour = if ("hour" in $in) {$rec.hour} else {"00"}
    let minute = if ("minute" in $in) {$rec.minute} else {"00"}
    $"($hour):($minute)"
}

def get_records [...query] {
    let query = if ($query == []) {["today"]} else {$query}
    (
        atl ls ...$query -O json | complete | get stdout | from json --objects |
        upsert fields.start {|r| $r.fields.start | first | into datetime } |
        upsert fields.project {|r| if "project" in $r.fields {$r.fields.project | first} else {null}} |
        upsert fields.end {|r| if (($r.fields.end | length) == 0) {null} else { $r.fields.end| first | into datetime }} |
        insert fields.day {|r| $r.fields.start | get_start_of_day} |
        insert fields.duration {|r| if ($r.fields.end != null) {$r.fields.end - $r.fields.start} else {(date now) - $r.fields.start}}
    )
}

export def "atl hours" [query: string="month", --json] {
    let records = get_records $query | get fields
    let projects = $records | group-by project

    let result = ($projects | transpose project records | each {
        |project| {
            project: $project.project,
            days: (
                $project.records | group-by day | transpose day records | each {|day|
                    {
                        day: ($day.day | if ($json) {$in} else {format date "%Y-%m-%d"}),
                        duration: ($day.records.duration | math sum | if ($json) {$in} else {format duration hr} ),
                    }
                }
            ),
            sum: ($project.records.duration | math sum | if ($json) {$in} else {format duration hr}),
        }
    })
    if $json {$result | to json} else { $result }
}

def _cmpl_id [line: string] {
  get_records | reverse | reduce --fold [] {
    |it,acc| $acc ++ {
        value: $it.id,
        description: $"($it.fields.start | format date '%F %T') \(($it.fields.duration | format duration hr)\) ($it.fields.project)"
    }
  }
}

def _cmpl_mod [line: string] {
    let words = $line | split row -r `\s+` | skip 2
    match ($words | length) {
        $i if $i <= 1 => {_cmpl_id $line | each {|it| {value: $"id=($it.value)", description: $it.description}}},
        2 => {["set"]},
        _ => {
            let id = $words | first
            get_records "month" | first | get fields | reject day duration | columns | each {|it| $"($it)="}
        }
    }
}

export def --wrapped "atl mod" [...args: string@_cmpl_mod] {
    ^atl mod ...$args
}

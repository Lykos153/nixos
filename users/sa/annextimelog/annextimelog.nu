def _get_contracts []: nothing -> table<string: int> {
    atl git cat-file blob main:contracts.yaml | from yaml
}

def _get_projects []: nothing -> record {
    atl git cat-file blob main:projects.yaml | from yaml
}

def _list_projects []: nothing -> list<string> {
    (_get_projects
        | transpose name details
        | update details {
            |project| $project.details | default {} | merge {id: ($in | get id -o)}
        }
        | sort-by details.id
        | reduce --fold [] {|project,pAcc|
            $pAcc ++ [$project.name] ++ (
                if (($project.details != null) and ("tasks" in ($project.details))) {
                    $project.details.tasks
                        | transpose alias name
                        | reduce --fold [] {|task,tAcc|
                            $tAcc ++ [$"($project.name).($task.alias)"]
                        }
                } else {[]})
        }
    )
}

def _cmpl_project []: nothing -> list<string> {
    _list_projects
}

def _end_of_last []: nothing -> string {
    (atl ls since 24h ago -O json | complete | get stdout | from json --objects | get fields.end | sort | last | last)
}

def _cmpl_at []: nothing -> list<string> {
    [
        now
        (_end_of_last)
    ]
}

def _cmpl_tag []: nothing -> list<string> {
    atl git annex metadata -j | from json --objects | get fields | where {|r| "tag" in ($r | columns)} | get tag | reduce {|r,acc| $acc ++ $r } | uniq -c | sort-by -r count | get value
}

export def "atl start" [--at: string@_cmpl_at="now", project: string@_cmpl_project, ...args: string@_cmpl_tag ]: nothing -> string {
    atl stop $at; atl track $"start=($at)" $"project=($project)" ...$args
}

export def "atl now" [project: string@_cmpl_project, ...args: string@_cmpl_tag ]: nothing -> string {
    atl track $"start=(_end_of_last)" $"project=($project)" ...$args
}

export def "atl done" [project: string@_cmpl_project, ...args: string@_cmpl_tag ]: nothing -> string {
    atl track $"start=(_end_of_last)" $"project=($project)" end=now ...$args
}

export def "atl cancel" []: nothing -> string {
    atl rm .open
}

export def "atl sum" [...query: string]: nothing -> string {
    let query = if ($query == []) {["today"]} else {$query}
    get_records ...$query | get fields.duration | math sum | render_time
}

export def "atl away" [day: datetime, reason: string, --until: datetime ...$tags]: nothing -> string {
    let hours_per_day = (_get_contracts | sort-by start --reverse | first | get hours-per-week) / 5

    let track_away_day = {|day|
        let formatted_day = $day | format date "%Y-%m-%d"
        atl track $"($formatted_day)T10:00" - $"($formatted_day)T(10 + $hours_per_day | into int):00" project=abwesenheit $reason ...$tags
    }

    if ($until != null) {
        generate {|day|
            {
                out: $day,
                next: ($day + 1day),
            }
        } $day
        | where {not (($in | format date %a) in ["Sun" "Sat" "Sa" "So"]) } # how to ensure english here?
        | take until {$in > $until}
        | each {$in | format date %Y-%m-%d}
        | each {do $track_away_day $in}
    } else {
        do $track_away_day $day
    }

}

def get_start_of_day []: datetime -> datetime {
    into record | $"($in.year)-($in.month)-($in.day)" | into datetime
}

def pad_num []: int -> string {
     fill --character "0" --alignment right --width 2
}

def render_time []: duration -> string {
    let dur = $in
    let hours = $dur / 1hr | math floor | pad_num
    let minutes = $dur mod 1hr / 1min | math ceil | pad_num
    $"($hours):($minutes)"
}

def get_records [...query]: nothing -> table {
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

export def "atl hours" [...query: string, --json]: [
    nothing -> table<project: string, days: list<error>, sum: string>
    nothing -> string ] {
    let query = if ($query == []) {["week"]} else {$query}

    let records = get_records ...$query | get fields
    let projects = $records | group-by project

    let project_map = _get_projects
    let result = ($projects | transpose project records | each {
        |project|
            let parsed = ( $project.project
                | split column "." pname tname
                | first
            )
            let project_details = $project_map | get -o $parsed.pname | default {}
            {
            id: ($project_details | get -o id ),
            project: ($project_details | get -o name | default $parsed.pname ),
            task: (if ("tname" in ($parsed | columns)) {
                ($project_details | get -o tasks | default {} | get -o $parsed.tname | default $parsed.tname)
            }),
            days: (
                $project.records | update day {|r| $r.day | format date "%Y-%m-%d" } | group-by day | transpose day records | each {|day|
                    {
                        day: ($day.day),
                        duration: ($day.records.duration | math sum | if ($json) {$in / 1000 ** 3 } else {$in | render_time} ),
                    }
                }
            ),
            sum: ($project.records.duration | math sum | if ($json) {$in / 1000 ** 3 } else {$in | render_time}),
        }
    }) | sort-by id
    if $json {$result | to json} else { $result }
}

def _cmpl_id [line: string]: nothing -> table<value: string, description: string> {
  get_records | reverse | reduce --fold [] {
    |it,acc| $acc ++ [{
        value: $it.id,
        description: $"($it.fields.start | format date '%F %T') \(($it.fields.duration | format duration hr)\) ($it.fields.project)"
    }]
  }
}

def _cmpl_mod [line: string]: nothing -> table<value: string, description: string> {
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

# Import data from timewarrior
# Example: tw export | from json | atl import timew
export def "atl import timew" []: table -> nothing {
    let all_records = $in
    let all_projects = _list_projects

    ($in | each {|rec|
        let intersect = ($rec | get tags --optional | default [] | where {|tag| $tag in $all_projects} | sort-by { str length } )
        let project = if ($intersect != []) {$intersect | last} else {null}
        let tags = ($rec | get tags --optional | default [] | where {|tag| not ($tag in $intersect)})

        let args = (
            [
                $"start=($rec.start)"
                "imported-from=timew"
                $"imported-on=(date now | format date "%Y-%m-%d")"
            ]
            | append (if ("end" in $rec) {$"end=($rec.end)"} else {[]})
            | append (if ("annotation" in $rec) {$"note=($rec.annotation)"} else {[]})
            | append (if ($project != null) {$"project=($project)"} else {[]})
            | append $tags
        )

        atl track ...$args
    })
    null
}

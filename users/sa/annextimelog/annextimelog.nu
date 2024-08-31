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

def get_start_of_day [] {
    date to-record | $"($in.year)-($in.month)-($in.day)" | into datetime
}

def render_hours [] {

}

def sum_duration [] {
    reduce --fold 0sec {|i,acc| $acc + $i.duration}
}

def render_time [] {
    let rec = $in
    let hour = if ("hour" in $in) {$rec.hour} else {"00"}
    let minute = if ("minute" in $in) {$rec.minute} else {"00"}
    $"($hour):($minute)"
}

export def "atl hours" [--json] {
    let records = (atl ls month -O json | from json --objects | get fields |
        upsert start {|r| $r.start | first | into datetime } |
        upsert project {|r| if "project" in $r {$r.project | first} else {null}} |
        upsert end {|r| if (($r.end | length) == 0) {null} else { $r.end| first | into datetime }} |
        insert day {|r| $r.start | get_start_of_day} |
        insert duration {|r| if ($r.end != null) {$r.end - $r.start} else {(date now) - $r.start}}
    )
    let projects = $records | group-by project

    let result = ($projects | transpose project records | each {
        |project| {
            project: $project.project,
            days: (
                $project.records | group-by day | transpose day records | each {|day|
                    {
                        day: ($day.day | format date "%Y-%m-%d"),
                        duration: ($day.records | sum_duration | format duration hr ),
                    }
                }
            ),
            sum: ($project.records | sum_duration | format duration hr),
        }
    })
    if $json {$result | to json} else { $result }
}

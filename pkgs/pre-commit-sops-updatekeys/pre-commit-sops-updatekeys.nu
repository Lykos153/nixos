#!/usr/bin/env nu

def allTrue [] {
    all {|x| $x == true }
}

def boolToExit [] {
    exit (if $in { 0 } else {1})
}

def handleSops [] -> bool {
    open .sops.yaml | get creation_rules | each {
        let regex = if ($in.path_regex | str starts-with "^") {
            $in.path_regex | str substring 1..
        } else { $in.path_regex }

        fd --full-path -u $regex | lines | each {
            handleFile $in
        } | allTrue
    } | allTrue
}

def handleFile [ file: string] -> bool {
    print -e $"Handling ($file)"
    let result = sops updatekeys --yes $in | complete
    print -e $result.stderr
    return ($result.stderr =~ 'already up to date')
}

def main [...args: string] {
    $args | each { match $in {
        ".sops.yaml" => {handleSops},
        _ => {handleFile $in}
    }}  | allTrue | boolToExit
}

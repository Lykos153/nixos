export def "desec api" [verb: string, path: string] {
    let url = $"https://desec.io/api/v1/($path)"
    let headers = [Authorization $"Token ($env.DESEC_TOKEN)"]
    let cmd = match $verb {
        "get"    => {http get    --headers $headers $url}
        "post"   => {to json | http post   --headers $headers $url}
        "delete" => {http delete --headers $headers $url}
    }
    do $cmd
}

export def "desec domains list" [] {
    desec api get "domains/"
}

export def "desec domains info" [domain: string] {
    desec api get $"domains/($domain)/"
}

export def "desec domains zonefile" [domain: string] {
    desec api get $"domains/($domain)/zonefile/"
}

export def "desec domains find" [dns_name: string] {
    desec api get $"domains/?owns_qname=($dns_name)"
}

export def "desec domains create" [new_domain: string] {
    {"name": $new_domain} | desec api post "domains/"
}

export def "desec domains delete" [domain: string] {
    desec api delete $"domains/($domain)/"
}

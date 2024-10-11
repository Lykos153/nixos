export def "desec api" [
    verb: string,
    path: string,
    payload: record = {},
    --headers: list<string> = []
    ]: nothing -> any {
    let url = $"https://desec.io/api/v1/($path)"
    let headers = $headers ++ [Authorization $"Token ($env.DESEC_TOKEN)"]
    match $verb {
        "get"    => (http get    --headers $headers $url)
        "post"   => (http post   --headers $headers $url --content-type application/json $payload)
        "patch"  => (http patch  --headers $headers $url --content-type application/json $payload)
        "put"    => (http put    --headers $headers $url --content-type application/json $payload)
        "delete" => (http delete --headers $headers $url)
    }
}

## DOMAINS

export def "desec domain list" []: nothing -> table {
    desec api get "domains/"
}

def _cmpl_domain [] {
    desec domain list | get name
}

export def "desec domain info" [domain: string@_cmpl_domain]: nothing -> record {
    desec api get $"domains/($domain)/"
}

export def "desec domain zonefile" [domain: string@_cmpl_domain]: nothing -> string {
    desec api get $"domains/($domain)/zonefile/"
}

export def "desec domain find" [dns_name: string]: nothing -> record {
    desec api get $"domains/?owns_qname=($dns_name)"
}

export def "desec domain create" [new_domain: string]: nothing -> record {
    desec api post "domains/" {"name": $new_domain}
}

export def "desec domain delete" [domain: string@_cmpl_domain]: nothing -> nothing {
    desec api delete $"domains/($domain)/"
}

## TOKENS

export def "desec token list" []: nothing -> table {
    desec api get "auth/tokens/"
}

export def "desec token info" [token: string@_cmpl_token]: nothing -> record {
    desec api get $"auth/tokens/($token)/"
}

export def "desec token delete" [token: string@_cmpl_token]: nothing -> nothing {
    desec api delete $"auth/tokens/($token)/"
}

def upsert-if-not-null [field: string, value: any] {
    if ($value != null) {upsert $field $value} else {echo $in}
}

def duration-to-seconds [] {
    let value = $in
    if ($value == null) { null } else {
        $value | into int | $in / 10 ** 9
    }
}

export def "desec token create" [
    name?: string,
    --allowed-subnets: list<string>,
    --manage-tokens,
    --max-age: duration,
    --max-unused-period: duration,
    ]: nothing -> record {
    desec api post "auth/tokens/" ({
        perm_manage_tokens: $manage_tokens,
        max_age: ($max_age | duration-to-seconds),
        max_unused_period: ($max_unused_period | duration-to-seconds),
      }
      | upsert-if-not-null name $name
      | upsert-if-not-null allowed_subnets $allowed_subnets
    )
}

def _cmpl_token [] {
    desec token list | each {|token| {value: $token.id, description: $token.name }}
}

export def "desec token update" [
    id: string@_cmpl_token,
    name?: string,
    --allowed-subnets: list<string>,
    --manage-tokens,
    --max-age: duration,
    --max-unused-period: duration,
    ]: nothing -> record {
    desec api patch $"auth/tokens/$(id)" ({
        perm_manage_tokens: $manage_tokens,
        max_age: ($max_age | duration-to-seconds),
        max_unused_period: ($max_unused_period | duration-to-seconds),
      }
      | upsert-if-not-null name $name
      | upsert-if-not-null allowed_subnets $allowed_subnets
    )
}

export def "desec token policy list" [
    token: string@_cmpl_token
    ]: nothing -> table {
    desec api get $"auth/tokens/($token)/policies/rrsets/"
}

def _cmpl_record_type [] {
    [
        A, AAAA, AFSDB, APL, CAA, CDNSKEY, CDS, CERT, CNAME,
        CSYNC, DHCID, DLV, DNAME, DNSKEY, DS, "EUI48", "EUI64",
        HINFO, HIP, HTTPS, IPSECKEY, KEY, KX, LOC, MX, NAPTR,
        NS, NSEC, "NSEC3", "NSEC3PARAM", OPENPGPKEY, PTR, RP,
        RRSIG, SIG, SMIMEA, SOA, SRV, SSHFP, SVCB, TA, TKEY,
        TLSA, TSIG, TXT, URI, ZONEMD
    ]
}

export def "desec token policy create" [
    token: string@_cmpl_token,
    --domain: string@_cmpl_domain,
    --subname: string,
    --type: string@_cmpl_record_type,
    --perm_write,
    ]: nothing -> record {
    desec api post $"auth/tokens/($token)/policies/rrsets/" {
        perm_write: $perm_write,
        domain: $domain
        subname: $subname
        type: $type
    }
}

def _cmpl_policy [line: string] {
    let line = $line | split row -r '\s+'
    let token = $line | skip 4 | first
    desec token policy list $token | each {|pol| {
        value: $pol.id,
        description: $"($pol.type) ($pol.subname) ($pol.domain) \((if $pol.perm_write {"rw"} else {"ro"})\)"
    }}
}

export def "desec token policy info" [token: string@_cmpl_token, policy: string@_cmpl_policy] {
    desec api get $"auth/tokens/($token)/policies/rrsets/($policy)/"
}

export def "desec token policy delete" [
    token: string@_cmpl_token,
    policy: string@_cmpl_policy
    ]: nothing -> nothing {
    desec api delete $"auth/tokens/($token)/policies/rrsets/($policy)/"
}

def _cmpl_perm_write [] {
    [yes no]
}

export def "desec token policy update" [
    token: string@_cmpl_token,
    policy: string@_cmpl_policy
    --domain: string@_cmpl_domain,
    --subname: string,
    --type: string@_cmpl_record_type,
    --perm_write: string@_cmpl_perm_write,
    ]: nothing -> record {
    desec api patch $"auth/tokens/($token)/policies/rrsets/($policy)/" ({}
        | upsert-if-not-null perm_write (
            match $perm_write {
                "yes"   => true
                "no"    => false
                null    => null
                $invalid  => $invalid
            }
        )
        | upsert-if-not-null domain $domain
        | upsert-if-not-null subname $subname
        | upsert-if-not-null type $type
    )
}


## misc

export def "desec logout" []: nothing -> nothing {
   desec api post "auth/logout/"
}

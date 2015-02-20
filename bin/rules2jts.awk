#!/usr/bin/awk -F, -f

#usage: for csv in ./examples/afgo/*.rules.csv; do ./rules2jts.awk $csv > "${csv/.rules.csv/.json}"; done;

BEGIN {
    FS=","
}

$1 == "headers" {
    split($3,headers,"|")
}

$1 == "field" {
    rule_type=$2
    split($3,params," ")
    field_name=params[1]
    args=params[2]

    if (rule_type == "values") {
        type="\"string\""
        constraint="\"pattern\": \"/^(" args ")$/\""
    } else if (rule_type ~ "^(min|max)$") {
        type="\"number\""
        constraint="\"" rule_type "\": " args
    } else {
        type="\"string\""
        constraint="\"" rule_type "\": true"
    }

    types[field_name] = type
    constraints[field_name] = constraints[field_name] ? constraints[field_name] FS constraint : constraint
}

END {
    print "{ \"path\": \"" FILENAME "\", \"schema\": { \"fields\": ["

    l=length(constraints)
    for (i = 1; i <= l; i++) {
        field = headers[i]
        print "{\"name\":" "\"" field "\"" FS "\"type\":" types[field] FS "\"constraints\": {" constraints[field] "}}"
        if(i!=l) print FS
    }
    
    print "] } }"
}
#!/usr/bin/awk -F, -f

BEGIN {
    FS=","
    print "#!/usr/bin/awk -F, -f" RS

    print "# generated by: awk-csvalid https://github.com/tesera/awk-csvalid" RS
    print "# awk-csvalid csv toolset generator: https://github.com/tesera/awk-csvalid"
    print "# usage:"
    print "#    validate:     awk -f action=validate validator.awk > violations.txt"
    print "#    create table: awk -v action=table -f validator.awk | psql afgo_dev"
    print "#    sanitize csv: awk -v action=sanitize -f validator.awk > sanitized.csv"
    print "#    insert sql:   awk -v action=insert -f validator.awk | psql afgo_dev" RS
    print "# awk is a simple unix text file parser: http://www.gnu.org/software/gawk/manual/gawk.html"
    print "# awk primer:"
    print "#    NR = number/index current record"
    print "#    RS = record seperator new line i.e. \\n"
    print "#    FS = field seperator i.e. ,"
    print "#    /pattern/ { expression } = if pattern is truthy run expression" RS

    print "BEGIN {"
    print "    FS=\",\"; OFS=\",\"; err_count=0; cats[\"na\"]=0;"
    print "    if(!action) action = \"validate\""
    print "    summary_header=\"file_name,field_name,rule,message,violation_count\""
    print "    CSVFILENAME = CSVFILENAME ? CSVFILENAME : FILENAME"
    print "    FPAT = \"([^,]*)|(\\\"[^\\\"]+\\\")\""
    print "}" RS

    print "# builtin helper functions"
    print "function eql(x,y) {v=1; for (i in x) v=(v&&x[i]==y[i]); return v;}"
    print "function are_headers_valid(valid_headers) { v=0; split($0, h, \",\"); split(valid_headers, vh, \"|\"); return eql(h, vh); }"
    print "function is_unique(i, val) { if (vals[i,val]) { return 0; } else { vals[i,val] = 1; return 1; } }"
    print "function is_integer(x) { return x ~ /^-?[0-9]+$/ }"
    print "function is_number(x) { return x ~ /^-?[0-9]+(\.[0-9]+)?$/ }"
    print "function print_cats(categories) { for (category in categories) { if (categories[category]) print \"      \" category \": \" categories[category]; } }"
    print "function log_err(cat) { cats[cat]++; err_count++; }"
    print RS
    print "#get rid of the evil windows cr"
    print "{ sub(\"\\r$\", \"\") }"
    print RS
    print "{"
    print "     for (i = 1; i <= NF; i++) {"
    print "         if (substr($i, 1, 1) == \"\\\"\") {"
    print "             len = length($i)"
    print "             $i = substr($i, 2, len - 2)"
    print "         }"
    print "     }"
    print "}"
    print RS
}

# BUILD OPTIONS MAP
$1 == "option" {
    options[$2]=$3;
}

# RENDER PFKEY CHECK
$1 == "file" {
    file_options[$2]=$3;
    if ($2 == "pkey") {
        pkeys=$3
        gsub(/\|/, " \"-\" ", pkeys)
        pkeycheck="action ~ /validate/ && NR > 1 { pkey=" pkeys "; if(keys[pkey]) { if (dupkeys[pkey]) dupkeys[pkey]++; else dupkeys[pkey] = 1 } else { keys[pkey] = NR } }"
    }
}

# RENDER HEADERS CHECK
$1 == "headers" && $2 == "names" {
    split($3, headers, "|")
    print "# make header index/map"
    print "NR > 1 {"
    print "field_width = " length(headers)
    for (i in headers) {
        header_name = headers[i]
        header_index[header_name] = i
        print "    " headers[i]  "=$" i
    }

    print "}" RS
    print "# awk rules based on user csv ruleset"
    print "NR == 1 && action == \"validate\" { headers=\"" $3 "\"; if (!are_headers_valid(headers)) { gsub(/\\|/, FS, headers); print  NR FS CSVFILENAME FS \"header\" FS \"invalid-header\" FS \"error\" FS  \"headers are invalid \"; exit 0;} }"
    print "NR == 1 && action == \"validate:summary\" { headers=\"" $3 "\"; if (!are_headers_valid(headers)) { violations[CSVFILENAME FS \"headers\" FS  \"names\" FS \"csv headers are invalid\" FS \"error\"]=1; exit 0; } }"
    print pkeycheck
    cat = "error"
    test = "NF != field_width"
    msg = "row \" NR \" in \" CSVFILENAME \" has \" NF \" columns and \" field_width \" was expected"
    mini_msg = "row \" NR \" has an invalid column count"
    rule_type = "invalid-column-count"
    # print "action ~ /^validate/ && NR > 1 { if(NF != field_width) { print \"row \" NR \" in \" CSVFILENAME \" has \" NF \" records and \" field_width \" was expected\"; next;} }"
}

{
    # SET DEFAULTS IF NOT PASSED IN VIA RULES
    defaults["mode"]    = "violation"
    defaults["summary"] = "true"
    defaults["dcat"]    = "warning"
    for (option in defaults) {
        if (!options[option]) options[option] = defaults[option]
    }
}

# RENDER VALUE CHECKS
$1 == "field" {

    # PARSE RULE FIELDS
    rule_type     = $2
    split($3,params," ")
    field         = params[1]
    cat           = params[3]
    field_index   = header_index[field]
    test          = ""
    msg           = ""

    # BUILD VIOLATION TEST
    if (rule_type == "type") {
        type = params[2]

        if (type == "integer") {
            cat       = "error"
            test      = field " && !is_integer(" field ")"
            mini_msg  = field " should be an integer"
            msg       = "Field " field " in \" CSVFILENAME \" line \" NR \" should be an integer but was \" " field " \" "
        } else if (type == "number") {
            cat       = "error"
            test      = field " && !is_number(" field ")"
            mini_msg  = field " should be a decimal number"
            msg       = "Field " field " in \" CSVFILENAME \" line \" NR \" should be a decimal number but was \" " field " \" "
        }
    } else if (rule_type == "required") {
        req = params[2]

        if (req == "true") {
            test        = field " == \"\""
            mini_msg    = field " value is required but was empty"
            msg         = "Field " field " in \" CSVFILENAME \" line \" NR \" is required"
        } else if (req != "false") {
            test        = req " && " field " == \"\""
            mini_msg    = field " value is required if " req
            msg         = "Field " field " in \" CSVFILENAME \" line \" NR \" is required if " req
        }

    } else if (rule_type == "unique") {
        cat         = "error"
        test        = "!is_unique(" field ")"
        mini_msg    = field " value should be unique but had duplicates"
        msg         = "Field " field " in \" CSVFILENAME \" line \" NR \" is a duplicate and should be unique"

    } else if (rule_type ~ /^minimum|maximum$/) {
        comparator  = $2 == "maximum" ? ">" : "<"
        limit       = params[2]
        term        = $2 == "maximum" ? "less" : "greater"

        cat         = "error"
        test        = field " != \"\" && " field " " comparator " " limit
        mini_msg    = field " value should be " term " or equal to: " limit
        msg         = field " in \" CSVFILENAME \" line \" NR \" should be " term " or equal to" limit " and was \" " field " \" "

    } else if (rule_type == "pattern") {
        pattern     = params[2]

        cat         = "error"
        test        = field " != \"\" && " field " !~ " pattern
        mini_msg    = field " value should match: " pattern
        msg         = field " in \" CSVFILENAME \" line \" NR \" should match the following pattern " pattern " and was \" " field " \" "

    } else if (rule_type ~ /^minLength|maxLength$/) {
        comparator  = $2 == "maxLength" ? ">" : "<"
        limit       = params[2]
        term        = $2 == "maxLength" ? "less" : "greater"

        cat         = "error"
        test        = field " != \"\" && length(" field ") " comparator " " limit
        mini_msg    = field " max length is: " limit
        msg         = field " length in \" CSVFILENAME \" line \" NR \" should be " term " or equal to " limit " and was \" length(" field ") \" "
    }
}

{
    # RENDER VIOLATION HANDLER
    if (test) {
        if (!cat) cat = options["dcat"]
        handler_prefix = "{ log_err(\"" cat "\"); "

        if (options["mode"] == "text") {
            err_handler = handler_prefix "print \"" msg "\" RS $0 RS; }"

        } else if (options["mode"] == "wrap") {
            acc = "$" field_index
            err_handler = handler_prefix "FS=\",\";" acc "=\">>\" " acc " \"<<\"; print $0 }"

        } else if (options["mode"] == "append") {
            err_handler = handler_prefix "print $0 FS \"" msg "\" }"
        } else if (options["mode"] == "violation") {
            key=file_options["pkey"]
            gsub(/\|/, " \"-\" ", key)
            err_handler = handler_prefix "print  NR FS CSVFILENAME FS " key " FS \"" rule_type "\" FS \"" cat "\" FS  \"" mini_msg "\" FS \"" field "\"}"
        }

        if (rule_type != "none") {
            print "action == \"validate\" && NR > 1 && " test " " err_handler " "
            summary_handler = "key=CSVFILENAME FS \"" field "\" FS  \"" rule_type "\" FS \"" mini_msg "\" FS \"" cat "\"; if(!violations[key]) { violations[key]=0; } violations[key]++;"
            print "action == \"validate:summary\" && NR > 1 && " test " { " summary_handler " } "
        }
    }
}

# BUILD MAP OF SQL TYPES FOR SQL CREATE AND COPY
$1 == "field" {
    sql_types_map["string"] = "text"
    sql_types_map["integer"] = "integer"
    sql_types_map["number"] = "numeric"

    rule_type = $2 ? sql_types_map[$2] : sql_types_map["string"]

    split($3, params, " ")
    field = params[1]

    sql_types[field] = rule_type
}

END {
    # SANITIZE EMPTY VALUES TO PASSED IN DEFAULTS OR NULL
    print RS "# sanitize rules"
    print "action ~ /^(sanitize|insert)$/ && NR > 1 {"
    for (field in sql_types) {
        sql_type    = sql_types[field]
        field_index = header_index[field]
        dval        = sql_type == "numeric" ? options["dvalnum"] : options["dvalstr"]
        dval        = dval ? dval : "\\\\N"

        print "    if (" field " == \"\") $" field_index " = \"" dval "\""
    }
    print "}"

    # SQL COPY
    print RS "# action handlers"
    print "action == \"insert\" && NR == 1 {"
    print "    print \"SET client_encoding = 'UTF8';\""
    print "    print \"COPY \" schema \"" file_options["table"] " (\" addfields FS \"source_row_index\" FS $0 \") FROM stdin;\""
    print "}"

    print   "action == \"insert\" && NR > 1 {"
    print   "   record = addvals \"\\t\" NR"
    print   "   for (i = 1; i <= NF; i++) {"
    print   "       record = record \"\\t\" $i"
    print   "   }"
    print   "   print record"
    print   "}"

    # SQL CREATE TABLE
    print "action == \"table\" && NR == 1 {"
    fields=""
    for (i = 1; i <= length(headers); i++) {
        field     = headers[i]
        sql_type  = sql_types[field]
        fields    = fields field " " sql_type
        if (i < length(headers)) fields = fields ","
    }

    if(file_options["pkey"]) {
        cols    = file_options["pkey"]
        gsub(/\|/, ",", cols)
        fields  = fields ", CONSTRAINT " file_options["table"] "_pkey PRIMARY KEY (" cols ") "
    }
    if(file_options["fkey"]) {
        split(file_options["fkey"], ref, " ")
        ftable  = ref[1]
        fcols   = ref[2]
        gsub(/\|/, ",", fcols)
        fields  = fields ", CONSTRAINT " file_options["table"] "_" ftable "_fkey FOREIGN KEY (" fcols ") REFERENCES " ftable " (" fcols ") MATCH FULL "
        fields  = fields "ON UPDATE CASCADE ON DELETE NO ACTION"
    }
    print "     print \"CREATE TABLE IF NOT EXISTS " file_options["table"] " (" fields ");\""
    print "}"

    print "action == \"sanitize\" { print }"

    # END
    print "# la fin"
    print "END {"
    print "    if (action == \"validate:summary\" && length(dupkeys) > 0) for (dup in dupkeys) { violation=CSVFILENAME FS \"" file_options["pkey"] "\" FS  \"duplicate\" FS dup \" violates pkey\" FS \"error\"; violations[violation] = dupkeys[dup]}"
    print "    if (action == \"validate:summary\") { if (length(violations) > 0) for (violation in violations) { print violation FS violations[violation]; } }"
    print "    if (action == \"insert\") print \"\\\\.\" RS"
    print "    if (action == \"validate\" && options[\"summary\"] == \"true\") { print RS \"violation summary: \" RS \"   counts:   \" RS \"      total: \" err_count; print_cats(cats); }"
    print "}"
}

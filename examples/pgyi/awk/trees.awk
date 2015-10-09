#!/usr/bin/awk -F, -f

# generated by: awk-csvalid https://github.com/tesera/awk-csvalid

# awk-csvalid csv toolset generator: https://github.com/tesera/awk-csvalid
# usage:
#    validate:     awk -f action=validate validator.awk > violations.txt
#    create table: awk -v action=table -f validator.awk | psql afgo_dev
#    sanitize csv: awk -v action=sanitize -f validator.awk > sanitized.csv
#    insert sql:   awk -v action=insert -f validator.awk | psql afgo_dev

# awk is a simple unix text file parser: http://www.gnu.org/software/gawk/manual/gawk.html
# awk primer:
#    NR = number/index current record
#    RS = record seperator new line i.e. \n
#    FS = field seperator i.e. ,
#    /pattern/ { expression } = if pattern is truthy run expression

BEGIN {
    FS=","; OFS=","; err_count=0; cats["na"]=0;
    if(!action) action = "validate"
    summary_header="file_name,field_name,rule,message,violation_count"
    CSVFILENAME = CSVFILENAME ? CSVFILENAME : FILENAME
    FPAT = "([^,]*)|(\"[^\"]+\")"
}

# builtin helper functions
function eql(x,y) {v=1; for (i in x) v=(v&&x[i]==y[i]); return v;}
function are_headers_valid(valid_headers) { v=0; split($0, h, ","); split(valid_headers, vh, "|"); return eql(h, vh); }
function is_unique(i, val) { if (vals[i,val]) { return 0; } else { vals[i,val] = 1; return 1; } }
function is_integer(x) { return x ~ /^-?[0-9]+$/ }
function is_number(x) { return x ~ /^-?[0-9]+(.[0-9]+)?$/ }
function print_cats(categories) { for (category in categories) { if (categories[category]) print "      " category ": " categories[category]; } }
function log_err(cat) { cats[cat]++; err_count++; }


#get rid of the evil windows cr
{ sub("\r$", "") }


{
     for (i = 1; i <= NF; i++) {
         if (substr($i, 1, 1) == "\"") {
             len = length($i)
             $i = substr($i, 2, len - 2)
         }
     }
}


# make header index/map
NR > 1 {
field_width = 11
    company=$1
    company_plot_number=$2
    tree_number=$3
    tree_label=$4
    tree_location_id=$5
    tree_origin=$6
    sector_or_quarter=$7
    species=$8
    distance=$9
    azimuth=$10
    trees_comment=$11
}

# awk rules based on user csv ruleset
NR == 1 && action == "validate" { headers="company|company_plot_number|tree_number|tree_label|tree_location_id|tree_origin|sector_or_quarter|species|distance|azimuth|trees_comment"; if (!are_headers_valid(headers)) { gsub(/\|/, FS, headers); print  NR FS CSVFILENAME FS "header" FS "invalid-header" FS "error" FS  "headers are invalid "; exit 0;} }
NR == 1 && action == "validate:summary" { headers="company|company_plot_number|tree_number|tree_label|tree_location_id|tree_origin|sector_or_quarter|species|distance|azimuth|trees_comment"; if (!are_headers_valid(headers)) { violations[CSVFILENAME FS "headers" FS  "names" FS "csv headers are invalid" FS "error"]=1; exit 0; } }

action == "validate" && NR > 1 && NF != field_width { log_err("error"); print  NR FS CSVFILENAME FS  FS "invalid-column-count" FS "error" FS  "row " NR " has an invalid column count" FS ""} 
action == "validate:summary" && NR > 1 && NF != field_width { key=CSVFILENAME FS "" FS  "invalid-column-count" FS "row " NR " has an invalid column count" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company == "" { log_err("error"); print  NR FS CSVFILENAME FS  FS "required" FS "error" FS  "company value is required but was empty" FS "company"} 
action == "validate:summary" && NR > 1 && company == "" { key=CSVFILENAME FS "company" FS  "required" FS "company value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company != "" && company !~ /^(AINS|ALPC|ANC|APLY|BLUE|CFPL|CFS|DAIS|FOFP|GOA|HPFP|HLFP|MDFP|MWWC|SFPI|SLPC|SPRA|SUND|TOLK|TOSL|UNKN|UOA|VAND|WFML|WYGP|WYPM)$/ { log_err("error"); print  NR FS CSVFILENAME FS  FS "pattern" FS "error" FS  "company value should match: /^(AINS|ALPC|ANC|APLY|BLUE|CFPL|CFS|DAIS|FOFP|GOA|HPFP|HLFP|MDFP|MWWC|SFPI|SLPC|SPRA|SUND|TOLK|TOSL|UNKN|UOA|VAND|WFML|WYGP|WYPM)$/" FS "company"} 
action == "validate:summary" && NR > 1 && company != "" && company !~ /^(AINS|ALPC|ANC|APLY|BLUE|CFPL|CFS|DAIS|FOFP|GOA|HPFP|HLFP|MDFP|MWWC|SFPI|SLPC|SPRA|SUND|TOLK|TOSL|UNKN|UOA|VAND|WFML|WYGP|WYPM)$/ { key=CSVFILENAME FS "company" FS  "pattern" FS "company value should match: /^(AINS|ALPC|ANC|APLY|BLUE|CFPL|CFS|DAIS|FOFP|GOA|HPFP|HLFP|MDFP|MWWC|SFPI|SLPC|SPRA|SUND|TOLK|TOSL|UNKN|UOA|VAND|WFML|WYGP|WYPM)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company_plot_number == "" { log_err("error"); print  NR FS CSVFILENAME FS  FS "required" FS "error" FS  "company_plot_number value is required but was empty" FS "company_plot_number"} 
action == "validate:summary" && NR > 1 && company_plot_number == "" { key=CSVFILENAME FS "company_plot_number" FS  "required" FS "company_plot_number value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company_plot_number != "" && length(company_plot_number) > 15 { log_err("error"); print  NR FS CSVFILENAME FS  FS "maxLength" FS "error" FS  "company_plot_number max length is: 15" FS "company_plot_number"} 
action == "validate:summary" && NR > 1 && company_plot_number != "" && length(company_plot_number) > 15 { key=CSVFILENAME FS "company_plot_number" FS  "maxLength" FS "company_plot_number max length is: 15" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_number != "" && !is_integer(tree_number) { log_err("error"); print  NR FS CSVFILENAME FS  FS "type" FS "error" FS  "tree_number should be an integer" FS "tree_number"} 
action == "validate:summary" && NR > 1 && tree_number != "" && !is_integer(tree_number) { key=CSVFILENAME FS "tree_number" FS  "type" FS "tree_number should be an integer" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_number == "" { log_err("error"); print  NR FS CSVFILENAME FS  FS "required" FS "error" FS  "tree_number value is required but was empty" FS "tree_number"} 
action == "validate:summary" && NR > 1 && tree_number == "" { key=CSVFILENAME FS "tree_number" FS  "required" FS "tree_number value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_number != "" && tree_number < 0 { log_err("error"); print  NR FS CSVFILENAME FS  FS "minimum" FS "error" FS  "tree_number value should be greater or equal to: 0" FS "tree_number"} 
action == "validate:summary" && NR > 1 && tree_number != "" && tree_number < 0 { key=CSVFILENAME FS "tree_number" FS  "minimum" FS "tree_number value should be greater or equal to: 0" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_number != "" && tree_number > 9999999 { log_err("error"); print  NR FS CSVFILENAME FS  FS "maximum" FS "error" FS  "tree_number value should be less or equal to: 9999999" FS "tree_number"} 
action == "validate:summary" && NR > 1 && tree_number != "" && tree_number > 9999999 { key=CSVFILENAME FS "tree_number" FS  "maximum" FS "tree_number value should be less or equal to: 9999999" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_label != "" && length(tree_label) > 15 { log_err("error"); print  NR FS CSVFILENAME FS  FS "maxLength" FS "error" FS  "tree_label max length is: 15" FS "tree_label"} 
action == "validate:summary" && NR > 1 && tree_label != "" && length(tree_label) > 15 { key=CSVFILENAME FS "tree_label" FS  "maxLength" FS "tree_label max length is: 15" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_location_id != "" && !is_integer(tree_location_id) { log_err("error"); print  NR FS CSVFILENAME FS  FS "type" FS "error" FS  "tree_location_id should be an integer" FS "tree_location_id"} 
action == "validate:summary" && NR > 1 && tree_location_id != "" && !is_integer(tree_location_id) { key=CSVFILENAME FS "tree_location_id" FS  "type" FS "tree_location_id should be an integer" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_location_id == "" { log_err("error"); print  NR FS CSVFILENAME FS  FS "required" FS "error" FS  "tree_location_id value is required but was empty" FS "tree_location_id"} 
action == "validate:summary" && NR > 1 && tree_location_id == "" { key=CSVFILENAME FS "tree_location_id" FS  "required" FS "tree_location_id value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_location_id != "" && tree_location_id !~ /^(0|1|2|3)$/ { log_err("error"); print  NR FS CSVFILENAME FS  FS "pattern" FS "error" FS  "tree_location_id value should match: /^(0|1|2|3)$/" FS "tree_location_id"} 
action == "validate:summary" && NR > 1 && tree_location_id != "" && tree_location_id !~ /^(0|1|2|3)$/ { key=CSVFILENAME FS "tree_location_id" FS  "pattern" FS "tree_location_id value should match: /^(0|1|2|3)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_origin != "" && !is_integer(tree_origin) { log_err("error"); print  NR FS CSVFILENAME FS  FS "type" FS "error" FS  "tree_origin should be an integer" FS "tree_origin"} 
action == "validate:summary" && NR > 1 && tree_origin != "" && !is_integer(tree_origin) { key=CSVFILENAME FS "tree_origin" FS  "type" FS "tree_origin should be an integer" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_origin == "" { log_err("error"); print  NR FS CSVFILENAME FS  FS "required" FS "error" FS  "tree_origin value is required but was empty" FS "tree_origin"} 
action == "validate:summary" && NR > 1 && tree_origin == "" { key=CSVFILENAME FS "tree_origin" FS  "required" FS "tree_origin value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_origin != "" && tree_origin !~ /^(0|1|2|3|4|5|6|7|8|9|10)$/ { log_err("error"); print  NR FS CSVFILENAME FS  FS "pattern" FS "error" FS  "tree_origin value should match: /^(0|1|2|3|4|5|6|7|8|9|10)$/" FS "tree_origin"} 
action == "validate:summary" && NR > 1 && tree_origin != "" && tree_origin !~ /^(0|1|2|3|4|5|6|7|8|9|10)$/ { key=CSVFILENAME FS "tree_origin" FS  "pattern" FS "tree_origin value should match: /^(0|1|2|3|4|5|6|7|8|9|10)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && sector_or_quarter != "" && length(sector_or_quarter) > 2 { log_err("error"); print  NR FS CSVFILENAME FS  FS "maxLength" FS "error" FS  "sector_or_quarter max length is: 2" FS "sector_or_quarter"} 
action == "validate:summary" && NR > 1 && sector_or_quarter != "" && length(sector_or_quarter) > 2 { key=CSVFILENAME FS "sector_or_quarter" FS  "maxLength" FS "sector_or_quarter max length is: 2" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && species == "" { log_err("error"); print  NR FS CSVFILENAME FS  FS "required" FS "error" FS  "species value is required but was empty" FS "species"} 
action == "validate:summary" && NR > 1 && species == "" { key=CSVFILENAME FS "species" FS  "required" FS "species value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && species != "" && species !~ /^(A|Aw|Ax|Bw|Dc|Dd|Du|Fa|Fb|Fd|La|Ls|Lt|Lw|Ms|P|Pa|Pb|Pf|Pj|Pl|Pw|Px|Sb|Se|Sw|Sx|No)$/ { log_err("error"); print  NR FS CSVFILENAME FS  FS "pattern" FS "error" FS  "species value should match: /^(A|Aw|Ax|Bw|Dc|Dd|Du|Fa|Fb|Fd|La|Ls|Lt|Lw|Ms|P|Pa|Pb|Pf|Pj|Pl|Pw|Px|Sb|Se|Sw|Sx|No)$/" FS "species"} 
action == "validate:summary" && NR > 1 && species != "" && species !~ /^(A|Aw|Ax|Bw|Dc|Dd|Du|Fa|Fb|Fd|La|Ls|Lt|Lw|Ms|P|Pa|Pb|Pf|Pj|Pl|Pw|Px|Sb|Se|Sw|Sx|No)$/ { key=CSVFILENAME FS "species" FS  "pattern" FS "species value should match: /^(A|Aw|Ax|Bw|Dc|Dd|Du|Fa|Fb|Fd|La|Ls|Lt|Lw|Ms|P|Pa|Pb|Pf|Pj|Pl|Pw|Px|Sb|Se|Sw|Sx|No)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && distance != "" && !is_number(distance) { log_err("error"); print  NR FS CSVFILENAME FS  FS "type" FS "error" FS  "distance should be a decimal number" FS "distance"} 
action == "validate:summary" && NR > 1 && distance != "" && !is_number(distance) { key=CSVFILENAME FS "distance" FS  "type" FS "distance should be a decimal number" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && distance != "" && distance < 0.01 { log_err("error"); print  NR FS CSVFILENAME FS  FS "minimum" FS "error" FS  "distance value should be greater or equal to: 0.01" FS "distance"} 
action == "validate:summary" && NR > 1 && distance != "" && distance < 0.01 { key=CSVFILENAME FS "distance" FS  "minimum" FS "distance value should be greater or equal to: 0.01" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && distance != "" && distance > 100 { log_err("error"); print  NR FS CSVFILENAME FS  FS "maximum" FS "error" FS  "distance value should be less or equal to: 100" FS "distance"} 
action == "validate:summary" && NR > 1 && distance != "" && distance > 100 { key=CSVFILENAME FS "distance" FS  "maximum" FS "distance value should be less or equal to: 100" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && distance != "" && distance !~ /^[0-9]*.[0-9]{2}$/ { log_err("error"); print  NR FS CSVFILENAME FS  FS "pattern" FS "error" FS  "distance value should match: /^[0-9]*.[0-9]{2}$/" FS "distance"} 
action == "validate:summary" && NR > 1 && distance != "" && distance !~ /^[0-9]*.[0-9]{2}$/ { key=CSVFILENAME FS "distance" FS  "pattern" FS "distance value should match: /^[0-9]*.[0-9]{2}$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && azimuth != "" && !is_number(azimuth) { log_err("error"); print  NR FS CSVFILENAME FS  FS "type" FS "error" FS  "azimuth should be a decimal number" FS "azimuth"} 
action == "validate:summary" && NR > 1 && azimuth != "" && !is_number(azimuth) { key=CSVFILENAME FS "azimuth" FS  "type" FS "azimuth should be a decimal number" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && azimuth != "" && azimuth < 0 { log_err("error"); print  NR FS CSVFILENAME FS  FS "minimum" FS "error" FS  "azimuth value should be greater or equal to: 0" FS "azimuth"} 
action == "validate:summary" && NR > 1 && azimuth != "" && azimuth < 0 { key=CSVFILENAME FS "azimuth" FS  "minimum" FS "azimuth value should be greater or equal to: 0" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && azimuth != "" && azimuth > 360 { log_err("error"); print  NR FS CSVFILENAME FS  FS "maximum" FS "error" FS  "azimuth value should be less or equal to: 360" FS "azimuth"} 
action == "validate:summary" && NR > 1 && azimuth != "" && azimuth > 360 { key=CSVFILENAME FS "azimuth" FS  "maximum" FS "azimuth value should be less or equal to: 360" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && azimuth != "" && azimuth !~ /^[0-9]*.[0-9]{1}$/ { log_err("error"); print  NR FS CSVFILENAME FS  FS "pattern" FS "error" FS  "azimuth value should match: /^[0-9]*.[0-9]{1}$/" FS "azimuth"} 
action == "validate:summary" && NR > 1 && azimuth != "" && azimuth !~ /^[0-9]*.[0-9]{1}$/ { key=CSVFILENAME FS "azimuth" FS  "pattern" FS "azimuth value should match: /^[0-9]*.[0-9]{1}$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && trees_comment != "" && length(trees_comment) > 250 { log_err("error"); print  NR FS CSVFILENAME FS  FS "maxLength" FS "error" FS  "trees_comment max length is: 250" FS "trees_comment"} 
action == "validate:summary" && NR > 1 && trees_comment != "" && length(trees_comment) > 250 { key=CSVFILENAME FS "trees_comment" FS  "maxLength" FS "trees_comment max length is: 250" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 

# sanitize rules
action ~ /^(sanitize|insert)$/ && NR > 1 {
    if (tree_number == "") $3 = "\\N"
    if (species == "") $8 = "\\N"
    if (distance == "") $9 = "\\N"
    if (tree_origin == "") $6 = "\\N"
    if (azimuth == "") $10 = "\\N"
    if (company_plot_number == "") $2 = "\\N"
    if (trees_comment == "") $11 = "\\N"
    if (company == "") $1 = "\\N"
    if (sector_or_quarter == "") $7 = "\\N"
    if (tree_location_id == "") $5 = "\\N"
    if (tree_label == "") $4 = "\\N"
}

# action handlers
action == "insert" && NR == 1 {
    print "SET client_encoding = 'UTF8';"
    print "COPY " schema "trees (" addfields FS "source_row_index" FS $0 ") FROM stdin;"
}
action == "insert" && NR > 1 {
   record = addvals "\t" NR
   for (i = 1; i <= NF; i++) {
       record = record "\t" $i
   }
   print record
}
action == "table" && NR == 1 {
     print "CREATE TABLE IF NOT EXISTS trees (company ,company_plot_number ,tree_number ,tree_label ,tree_location_id ,tree_origin ,sector_or_quarter ,species ,distance ,azimuth ,trees_comment );"
}
action == "sanitize" { print }
# la fin
END {
    if (action == "validate:summary" && length(dupkeys) > 0) for (dup in dupkeys) { violation=CSVFILENAME FS "" FS  "duplicate" FS dup " violates pkey" FS "error"; violations[violation] = dupkeys[dup]}
    if (action == "validate:summary") { if (length(violations) > 0) for (violation in violations) { print violation FS violations[violation]; } }
    if (action == "insert") print "\\." RS
    if (action == "validate" && options["summary"] == "true") { print RS "violation summary: " RS "   counts:   " RS "      total: " err_count; print_cats(cats); }
}

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
field_width = 7
    company=$1
    company_plot_number=$2
    measurement_number=$3
    regeneration_plot_name=$4
    species=$5
    regeneration_count=$6
    regeneration_comment=$7
}

# awk rules based on user csv ruleset
NR == 1 && action == "validate" { headers="company|company_plot_number|measurement_number|regeneration_plot_name|species|regeneration_count|regeneration_comment"; if (!are_headers_valid(headers)) { gsub(/\|/, FS, headers); print  NR FS CSVFILENAME FS "header" FS "invalid-header" FS "error" FS  "headers are invalid "; exit 0;} }
NR == 1 && action == "validate:summary" { headers="company|company_plot_number|measurement_number|regeneration_plot_name|species|regeneration_count|regeneration_comment"; if (!are_headers_valid(headers)) { violations[CSVFILENAME FS "headers" FS  "names" FS "csv headers are invalid" FS "error"]=1; exit 0; } }

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
action == "validate" && NR > 1 && measurement_number != "" && !is_integer(measurement_number) { log_err("error"); print  NR FS CSVFILENAME FS  FS "type" FS "error" FS  "measurement_number should be an integer" FS "measurement_number"} 
action == "validate:summary" && NR > 1 && measurement_number != "" && !is_integer(measurement_number) { key=CSVFILENAME FS "measurement_number" FS  "type" FS "measurement_number should be an integer" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && measurement_number == "" { log_err("error"); print  NR FS CSVFILENAME FS  FS "required" FS "error" FS  "measurement_number value is required but was empty" FS "measurement_number"} 
action == "validate:summary" && NR > 1 && measurement_number == "" { key=CSVFILENAME FS "measurement_number" FS  "required" FS "measurement_number value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && measurement_number != "" && length(measurement_number) > 2 { log_err("error"); print  NR FS CSVFILENAME FS  FS "maxLength" FS "error" FS  "measurement_number max length is: 2" FS "measurement_number"} 
action == "validate:summary" && NR > 1 && measurement_number != "" && length(measurement_number) > 2 { key=CSVFILENAME FS "measurement_number" FS  "maxLength" FS "measurement_number max length is: 2" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && regeneration_plot_name == "" { log_err("error"); print  NR FS CSVFILENAME FS  FS "required" FS "error" FS  "regeneration_plot_name value is required but was empty" FS "regeneration_plot_name"} 
action == "validate:summary" && NR > 1 && regeneration_plot_name == "" { key=CSVFILENAME FS "regeneration_plot_name" FS  "required" FS "regeneration_plot_name value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && regeneration_plot_name != "" && regeneration_plot_name !~ /^(R1|R2|R3|R4|R5|R6|R7|R8|R9|R10)$/ { log_err("error"); print  NR FS CSVFILENAME FS  FS "pattern" FS "error" FS  "regeneration_plot_name value should match: /^(R1|R2|R3|R4|R5|R6|R7|R8|R9|R10)$/" FS "regeneration_plot_name"} 
action == "validate:summary" && NR > 1 && regeneration_plot_name != "" && regeneration_plot_name !~ /^(R1|R2|R3|R4|R5|R6|R7|R8|R9|R10)$/ { key=CSVFILENAME FS "regeneration_plot_name" FS  "pattern" FS "regeneration_plot_name value should match: /^(R1|R2|R3|R4|R5|R6|R7|R8|R9|R10)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && species == "" { log_err("error"); print  NR FS CSVFILENAME FS  FS "required" FS "error" FS  "species value is required but was empty" FS "species"} 
action == "validate:summary" && NR > 1 && species == "" { key=CSVFILENAME FS "species" FS  "required" FS "species value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && species != "" && species !~ /^(A|Aw|Ax|Bw|Fa|Fb|Fd|La|Ls|Lt|Lw|Ms|P|Pa|Pb|Pf|Pj|Pl|Pw|Px|Sb|Se|Sw|Sx|No)$/ { log_err("error"); print  NR FS CSVFILENAME FS  FS "pattern" FS "error" FS  "species value should match: /^(A|Aw|Ax|Bw|Fa|Fb|Fd|La|Ls|Lt|Lw|Ms|P|Pa|Pb|Pf|Pj|Pl|Pw|Px|Sb|Se|Sw|Sx|No)$/" FS "species"} 
action == "validate:summary" && NR > 1 && species != "" && species !~ /^(A|Aw|Ax|Bw|Fa|Fb|Fd|La|Ls|Lt|Lw|Ms|P|Pa|Pb|Pf|Pj|Pl|Pw|Px|Sb|Se|Sw|Sx|No)$/ { key=CSVFILENAME FS "species" FS  "pattern" FS "species value should match: /^(A|Aw|Ax|Bw|Fa|Fb|Fd|La|Ls|Lt|Lw|Ms|P|Pa|Pb|Pf|Pj|Pl|Pw|Px|Sb|Se|Sw|Sx|No)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && regeneration_count != "" && !is_integer(regeneration_count) { log_err("error"); print  NR FS CSVFILENAME FS  FS "type" FS "error" FS  "regeneration_count should be an integer" FS "regeneration_count"} 
action == "validate:summary" && NR > 1 && regeneration_count != "" && !is_integer(regeneration_count) { key=CSVFILENAME FS "regeneration_count" FS  "type" FS "regeneration_count should be an integer" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && regeneration_count != "" && regeneration_count < 0 { log_err("error"); print  NR FS CSVFILENAME FS  FS "minimum" FS "error" FS  "regeneration_count value should be greater or equal to: 0" FS "regeneration_count"} 
action == "validate:summary" && NR > 1 && regeneration_count != "" && regeneration_count < 0 { key=CSVFILENAME FS "regeneration_count" FS  "minimum" FS "regeneration_count value should be greater or equal to: 0" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && regeneration_count != "" && regeneration_count > 9999 { log_err("error"); print  NR FS CSVFILENAME FS  FS "maximum" FS "error" FS  "regeneration_count value should be less or equal to: 9999" FS "regeneration_count"} 
action == "validate:summary" && NR > 1 && regeneration_count != "" && regeneration_count > 9999 { key=CSVFILENAME FS "regeneration_count" FS  "maximum" FS "regeneration_count value should be less or equal to: 9999" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && regeneration_comment != "" && length(regeneration_comment) > 250 { log_err("error"); print  NR FS CSVFILENAME FS  FS "maxLength" FS "error" FS  "regeneration_comment max length is: 250" FS "regeneration_comment"} 
action == "validate:summary" && NR > 1 && regeneration_comment != "" && length(regeneration_comment) > 250 { key=CSVFILENAME FS "regeneration_comment" FS  "maxLength" FS "regeneration_comment max length is: 250" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 

# sanitize rules
action ~ /^(sanitize|insert)$/ && NR > 1 {
    if (measurement_number == "") $3 = "\\N"
    if (species == "") $5 = "\\N"
    if (regeneration_plot_name == "") $4 = "\\N"
    if (company_plot_number == "") $2 = "\\N"
    if (regeneration_comment == "") $7 = "\\N"
    if (company == "") $1 = "\\N"
    if (regeneration_count == "") $6 = "\\N"
}

# action handlers
action == "insert" && NR == 1 {
    print "SET client_encoding = 'UTF8';"
    print "COPY " schema "regeneration (" addfields FS "source_row_index" FS $0 ") FROM stdin;"
}
action == "insert" && NR > 1 {
   record = addvals "\t" NR
   for (i = 1; i <= NF; i++) {
       record = record "\t" $i
   }
   print record
}
action == "table" && NR == 1 {
     print "CREATE TABLE IF NOT EXISTS regeneration (company text,company_plot_number text,measurement_number integer,regeneration_plot_name text,species text,regeneration_count text,regeneration_comment text);"
}
action == "sanitize" { print }
# la fin
END {
    if (action == "validate:summary" && length(dupkeys) > 0) for (dup in dupkeys) { violation=CSVFILENAME FS "" FS  "duplicate" FS dup " violates pkey" FS "error"; violations[violation] = dupkeys[dup]}
    if (action == "validate:summary") { if (length(violations) > 0) for (violation in violations) { print violation FS violations[violation]; } }
    if (action == "insert") print "\\." RS
    if (action == "validate" && options["summary"] == "true") { print RS "violation summary: " RS "   counts:   " RS "      total: " err_count; print_cats(cats); }
}

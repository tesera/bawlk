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
field_width = 8
    company=$1
    company_plot_number=$2
    disturbance_number=$3
    disturbance_code=$4
    disturbance_year=$5
    disturbance_month=$6
    disturbance_day=$7
    disturbance_comment=$8
}

# awk rules based on user csv ruleset
NR == 1 && action == "validate" { headers="company|company_plot_number|disturbance_number|disturbance_code|disturbance_year|disturbance_month|disturbance_day|disturbance_comment"; if (!are_headers_valid(headers)) { gsub(/\|/, FS, headers); print  NR FS CSVFILENAME FS "header" FS "invalid-header" FS "error" FS  "headers are invalid "; exit 0;} }
NR == 1 && action == "validate:summary" { headers="company|company_plot_number|disturbance_number|disturbance_code|disturbance_year|disturbance_month|disturbance_day|disturbance_comment"; if (!are_headers_valid(headers)) { violations[CSVFILENAME FS "headers" FS  "names" FS "csv headers are invalid" FS "error"]=1; exit 0; } }

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
action == "validate" && NR > 1 && disturbance_number != "" && !is_integer(disturbance_number) { log_err("error"); print  NR FS CSVFILENAME FS  FS "type" FS "error" FS  "disturbance_number should be an integer" FS "disturbance_number"} 
action == "validate:summary" && NR > 1 && disturbance_number != "" && !is_integer(disturbance_number) { key=CSVFILENAME FS "disturbance_number" FS  "type" FS "disturbance_number should be an integer" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && disturbance_number == "" { log_err("error"); print  NR FS CSVFILENAME FS  FS "required" FS "error" FS  "disturbance_number value is required but was empty" FS "disturbance_number"} 
action == "validate:summary" && NR > 1 && disturbance_number == "" { key=CSVFILENAME FS "disturbance_number" FS  "required" FS "disturbance_number value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && disturbance_number != "" && disturbance_number < 1 { log_err("error"); print  NR FS CSVFILENAME FS  FS "minimum" FS "error" FS  "disturbance_number value should be greater or equal to: 1" FS "disturbance_number"} 
action == "validate:summary" && NR > 1 && disturbance_number != "" && disturbance_number < 1 { key=CSVFILENAME FS "disturbance_number" FS  "minimum" FS "disturbance_number value should be greater or equal to: 1" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && disturbance_number != "" && disturbance_number > 12 { log_err("error"); print  NR FS CSVFILENAME FS  FS "maximum" FS "error" FS  "disturbance_number value should be less or equal to: 12" FS "disturbance_number"} 
action == "validate:summary" && NR > 1 && disturbance_number != "" && disturbance_number > 12 { key=CSVFILENAME FS "disturbance_number" FS  "maximum" FS "disturbance_number value should be less or equal to: 12" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && disturbance_code == "" { log_err("error"); print  NR FS CSVFILENAME FS  FS "required" FS "error" FS  "disturbance_code value is required but was empty" FS "disturbance_code"} 
action == "validate:summary" && NR > 1 && disturbance_code == "" { key=CSVFILENAME FS "disturbance_code" FS  "required" FS "disturbance_code value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && disturbance_code != "" && disturbance_code !~ /^(BU|DA|DC|DF|HL|MI|MLU|MU|NDD|NDW|NDC|NDI)$/ { log_err("error"); print  NR FS CSVFILENAME FS  FS "pattern" FS "error" FS  "disturbance_code value should match: /^(BU|DA|DC|DF|HL|MI|MLU|MU|NDD|NDW|NDC|NDI)$/" FS "disturbance_code"} 
action == "validate:summary" && NR > 1 && disturbance_code != "" && disturbance_code !~ /^(BU|DA|DC|DF|HL|MI|MLU|MU|NDD|NDW|NDC|NDI)$/ { key=CSVFILENAME FS "disturbance_code" FS  "pattern" FS "disturbance_code value should match: /^(BU|DA|DC|DF|HL|MI|MLU|MU|NDD|NDW|NDC|NDI)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && disturbance_year != "" && !is_integer(disturbance_year) { log_err("error"); print  NR FS CSVFILENAME FS  FS "type" FS "error" FS  "disturbance_year should be an integer" FS "disturbance_year"} 
action == "validate:summary" && NR > 1 && disturbance_year != "" && !is_integer(disturbance_year) { key=CSVFILENAME FS "disturbance_year" FS  "type" FS "disturbance_year should be an integer" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && disturbance_year == "" { log_err("warning"); print  NR FS CSVFILENAME FS  FS "required" FS "warning" FS  "disturbance_year value is required but was empty" FS "disturbance_year"} 
action == "validate:summary" && NR > 1 && disturbance_year == "" { key=CSVFILENAME FS "disturbance_year" FS  "required" FS "disturbance_year value is required but was empty" FS "warning"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && disturbance_year != "" && disturbance_year < 1900 { log_err("error"); print  NR FS CSVFILENAME FS  FS "minimum" FS "error" FS  "disturbance_year value should be greater or equal to: 1900" FS "disturbance_year"} 
action == "validate:summary" && NR > 1 && disturbance_year != "" && disturbance_year < 1900 { key=CSVFILENAME FS "disturbance_year" FS  "minimum" FS "disturbance_year value should be greater or equal to: 1900" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && disturbance_year != "" && disturbance_year > 2050 { log_err("error"); print  NR FS CSVFILENAME FS  FS "maximum" FS "error" FS  "disturbance_year value should be less or equal to: 2050" FS "disturbance_year"} 
action == "validate:summary" && NR > 1 && disturbance_year != "" && disturbance_year > 2050 { key=CSVFILENAME FS "disturbance_year" FS  "maximum" FS "disturbance_year value should be less or equal to: 2050" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && disturbance_month != "" && !is_integer(disturbance_month) { log_err("error"); print  NR FS CSVFILENAME FS  FS "type" FS "error" FS  "disturbance_month should be an integer" FS "disturbance_month"} 
action == "validate:summary" && NR > 1 && disturbance_month != "" && !is_integer(disturbance_month) { key=CSVFILENAME FS "disturbance_month" FS  "type" FS "disturbance_month should be an integer" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && disturbance_month == "" { log_err("warning"); print  NR FS CSVFILENAME FS  FS "required" FS "warning" FS  "disturbance_month value is required but was empty" FS "disturbance_month"} 
action == "validate:summary" && NR > 1 && disturbance_month == "" { key=CSVFILENAME FS "disturbance_month" FS  "required" FS "disturbance_month value is required but was empty" FS "warning"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && disturbance_month != "" && disturbance_month < 1 { log_err("error"); print  NR FS CSVFILENAME FS  FS "minimum" FS "error" FS  "disturbance_month value should be greater or equal to: 1" FS "disturbance_month"} 
action == "validate:summary" && NR > 1 && disturbance_month != "" && disturbance_month < 1 { key=CSVFILENAME FS "disturbance_month" FS  "minimum" FS "disturbance_month value should be greater or equal to: 1" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && disturbance_month != "" && disturbance_month > 12 { log_err("error"); print  NR FS CSVFILENAME FS  FS "maximum" FS "error" FS  "disturbance_month value should be less or equal to: 12" FS "disturbance_month"} 
action == "validate:summary" && NR > 1 && disturbance_month != "" && disturbance_month > 12 { key=CSVFILENAME FS "disturbance_month" FS  "maximum" FS "disturbance_month value should be less or equal to: 12" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && disturbance_day != "" && !is_integer(disturbance_day) { log_err("error"); print  NR FS CSVFILENAME FS  FS "type" FS "error" FS  "disturbance_day should be an integer" FS "disturbance_day"} 
action == "validate:summary" && NR > 1 && disturbance_day != "" && !is_integer(disturbance_day) { key=CSVFILENAME FS "disturbance_day" FS  "type" FS "disturbance_day should be an integer" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && disturbance_day == "" { log_err("warning"); print  NR FS CSVFILENAME FS  FS "required" FS "warning" FS  "disturbance_day value is required but was empty" FS "disturbance_day"} 
action == "validate:summary" && NR > 1 && disturbance_day == "" { key=CSVFILENAME FS "disturbance_day" FS  "required" FS "disturbance_day value is required but was empty" FS "warning"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && disturbance_day != "" && disturbance_day < 1 { log_err("error"); print  NR FS CSVFILENAME FS  FS "minimum" FS "error" FS  "disturbance_day value should be greater or equal to: 1" FS "disturbance_day"} 
action == "validate:summary" && NR > 1 && disturbance_day != "" && disturbance_day < 1 { key=CSVFILENAME FS "disturbance_day" FS  "minimum" FS "disturbance_day value should be greater or equal to: 1" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && disturbance_day != "" && disturbance_day > 31 { log_err("error"); print  NR FS CSVFILENAME FS  FS "maximum" FS "error" FS  "disturbance_day value should be less or equal to: 31" FS "disturbance_day"} 
action == "validate:summary" && NR > 1 && disturbance_day != "" && disturbance_day > 31 { key=CSVFILENAME FS "disturbance_day" FS  "maximum" FS "disturbance_day value should be less or equal to: 31" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && disturbance_comment != "" && length(disturbance_comment) > 250 { log_err("error"); print  NR FS CSVFILENAME FS  FS "maxLength" FS "error" FS  "disturbance_comment max length is: 250" FS "disturbance_comment"} 
action == "validate:summary" && NR > 1 && disturbance_comment != "" && length(disturbance_comment) > 250 { key=CSVFILENAME FS "disturbance_comment" FS  "maxLength" FS "disturbance_comment max length is: 250" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 

# sanitize rules
action ~ /^(sanitize|insert)$/ && NR > 1 {
    if (disturbance_month == "") $6 = "\\N"
    if (company_plot_number == "") $2 = "\\N"
    if (disturbance_code == "") $4 = "\\N"
    if (disturbance_number == "") $3 = "\\N"
    if (company == "") $1 = "\\N"
    if (disturbance_day == "") $7 = "\\N"
    if (disturbance_comment == "") $8 = "\\N"
    if (disturbance_year == "") $5 = "\\N"
}

# action handlers
action == "insert" && NR == 1 {
    print "SET client_encoding = 'UTF8';"
    print "COPY " schema "disturbance (" addfields FS "source_row_index" FS $0 ") FROM stdin;"
}
action == "insert" && NR > 1 {
   record = addvals "\t" NR
   for (i = 1; i <= NF; i++) {
       record = record "\t" $i
   }
   print record
}
action == "table" && NR == 1 {
     print "CREATE TABLE IF NOT EXISTS disturbance (company ,company_plot_number ,disturbance_number ,disturbance_code ,disturbance_year ,disturbance_month ,disturbance_day ,disturbance_comment );"
}
action == "sanitize" { print }
# la fin
END {
    if (action == "validate:summary" && length(dupkeys) > 0) for (dup in dupkeys) { violation=CSVFILENAME FS "" FS  "duplicate" FS dup " violates pkey" FS "error"; violations[violation] = dupkeys[dup]}
    if (action == "validate:summary") { if (length(violations) > 0) for (violation in violations) { print violation FS violations[violation]; } }
    if (action == "insert") print "\\." RS
    if (action == "validate" && options["summary"] == "true") { print RS "violation summary: " RS "   counts:   " RS "      total: " err_count; print_cats(cats); }
}

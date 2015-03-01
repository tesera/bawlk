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
}

# builtin helper functions
function eql(x,y) {v=1; for (i in x) v=(v&&x[i]==y[i]); return v;}
function are_headers_valid(valid_headers) { v=0; split($0, h, ","); split(valid_headers, vh, "|"); return eql(h, vh); }
function is_unique(i, val) { if (vals[i,val]) { return 0; } else { vals[i,val] = 1; return 1; } }
function is_numeric(x){ return(x==x+0) }
function print_cats(categories) { for (category in categories) { if (categories[category]) print "      " category ": " categories[category]; } }
function log_err(cat) { cats[cat]++; err_count++; }


#get rid of the evil windows cr
{ sub("\r$", "") }


# make header index/map
NR > 1 {
    company_plot_number=$2
    disturbance_number=$3
    disturbance_code=$4
    disturbance_year=$5
    disturbance_month=$6
    disturbance_day=$7
    disturbance_comment=$8
    company=$1
}

# awk rules based on user csv ruleset
NR == 1 { headers="company|company_plot_number|disturbance_number|disturbance_code|disturbance_year|disturbance_month|disturbance_day|disturbance_comment"; if (!are_headers_valid(headers)) print "invalid headers in " FILENAME }
action == "validate" && NR > 1 && company == "" { log_err("warning"); print "Field company in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && company != "" && company !~ /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ { log_err("warning"); print "company in " FILENAME " line " NR " should match the following pattern /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ and was " company " " RS $0 RS; } 
action == "validate" && NR > 1 && company_plot_number == "" { log_err("warning"); print "Field company_plot_number in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && disturbance_number && !is_numeric(disturbance_number) { log_err("warning"); print "Field disturbance_number in " FILENAME " line " NR " should be a numeric but was " disturbance_number " " RS $0 RS; } 
action == "validate" && NR > 1 && disturbance_number != "" && disturbance_number < 1 { log_err("warning"); print "disturbance_number in " FILENAME " line " NR " should be greater than 1 and was " disturbance_number " " RS $0 RS; } 
action == "validate" && NR > 1 && disturbance_number != "" && disturbance_number > 12 { log_err("warning"); print "disturbance_number in " FILENAME " line " NR " should be less than 12 and was " disturbance_number " " RS $0 RS; } 
action == "validate" && NR > 1 && disturbance_code != "" && disturbance_code !~ /^(BU|DF|MI|MU|NDD|NDW|DC|HL|MLU|NDC|NDI|FI|DA)$/ { log_err("warning"); print "disturbance_code in " FILENAME " line " NR " should match the following pattern /^(BU|DF|MI|MU|NDD|NDW|DC|HL|MLU|NDC|NDI|FI|DA)$/ and was " disturbance_code " " RS $0 RS; } 
action == "validate" && NR > 1 && disturbance_year && !is_numeric(disturbance_year) { log_err("warning"); print "Field disturbance_year in " FILENAME " line " NR " should be a numeric but was " disturbance_year " " RS $0 RS; } 
action == "validate" && NR > 1 && disturbance_year != "" && disturbance_year < 1900 { log_err("warning"); print "disturbance_year in " FILENAME " line " NR " should be greater than 1900 and was " disturbance_year " " RS $0 RS; } 
action == "validate" && NR > 1 && disturbance_year != "" && disturbance_year > 2050 { log_err("warning"); print "disturbance_year in " FILENAME " line " NR " should be less than 2050 and was " disturbance_year " " RS $0 RS; } 
action == "validate" && NR > 1 && disturbance_month && !is_numeric(disturbance_month) { log_err("warning"); print "Field disturbance_month in " FILENAME " line " NR " should be a numeric but was " disturbance_month " " RS $0 RS; } 
action == "validate" && NR > 1 && disturbance_month != "" && disturbance_month < 1 { log_err("warning"); print "disturbance_month in " FILENAME " line " NR " should be greater than 1 and was " disturbance_month " " RS $0 RS; } 
action == "validate" && NR > 1 && disturbance_month != "" && disturbance_month > 12 { log_err("warning"); print "disturbance_month in " FILENAME " line " NR " should be less than 12 and was " disturbance_month " " RS $0 RS; } 
action == "validate" && NR > 1 && disturbance_day && !is_numeric(disturbance_day) { log_err("warning"); print "Field disturbance_day in " FILENAME " line " NR " should be a numeric but was " disturbance_day " " RS $0 RS; } 
action == "validate" && NR > 1 && disturbance_day != "" && disturbance_day < 1 { log_err("warning"); print "disturbance_day in " FILENAME " line " NR " should be greater than 1 and was " disturbance_day " " RS $0 RS; } 
action == "validate" && NR > 1 && disturbance_day != "" && disturbance_day > 31 { log_err("warning"); print "disturbance_day in " FILENAME " line " NR " should be less than 31 and was " disturbance_day " " RS $0 RS; } 

# sanitize rules
action ~ /^(sanitize|insert)$/ && NR > 1 {
    if (disturbance_number == "") $3 = "-9999"
    if (disturbance_day == "") $7 = "-9999"
    if (disturbance_code == "") $4 = "NA"
    if (disturbance_year == "") $5 = "-9999"
    if (company_plot_number == "") $2 = "NA"
    if (disturbance_month == "") $6 = "-9999"
    if (disturbance_comment == "") $8 = "NA"
    if (company == "") $1 = "NA"
}

# action handlers
action == "insert" && NR == 1 {
    print "SET client_encoding = 'UTF8';"
    gsub("Range", "rangeno");
    print "COPY  (" $0 ") FROM stdin;"
}
action == "insert" && NR > 1 {
    gsub(",", "	");
    print;
}
action == "table" && NR == 1 {
     print "CREATE TABLE IF NOT EXISTS  (company_plot_number text,disturbance_number numeric,disturbance_code text,disturbance_year numeric,disturbance_month numeric,disturbance_day numeric,disturbance_comment text,company text);"
}
action == "sanitize" { print }

# la fin
END {
    if (action == "insert") print "\\."
    if (action == "validate" && options["summary"] == "true") { print RS "violation summary: " RS "   counts:   " RS "      total: " err_count; print_cats(cats); }
}

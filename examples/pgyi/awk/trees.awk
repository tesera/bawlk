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
function is_numeric(x){ return(x==x+0) }
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
NR == 1 && action == "validate" { headers="company|company_plot_number|tree_number|tree_label|tree_location_id|tree_origin|sector_or_quarter|species|distance|azimuth|trees_comment"; if (!are_headers_valid(headers)) { gsub(/\|/, FS, headers); print RS "INVALID HEADERS IN " CSVFILENAME RS "WAS: " RS $0 RS "EXPECTED:" RS headers RS; exit 0; } }
NR == 1 && action == "validate:summary" { headers="company|company_plot_number|tree_number|tree_label|tree_location_id|tree_origin|sector_or_quarter|species|distance|azimuth|trees_comment"; if (!are_headers_valid(headers)) { violations[CSVFILENAME FS "headers" FS  "names" FS "csv headers are invalid" FS "error"]=1; exit 0; } }
action ~ /validate/ && NR > 1 { pkey=company "-" company_plot_number "-" tree_number; if(keys[pkey]) { if (dupkeys[pkey]) dupkeys[pkey]++; else dupkeys[pkey] = 1 } else { keys[pkey] = NR } }
action == "validate" && NR > 1 && company == "" { log_err("error"); print "Field company in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && company == "" { key=CSVFILENAME FS "company" FS  "required" FS "value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company != "" && company !~ /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ { log_err("error"); print "company in " CSVFILENAME " line " NR " should match the following pattern /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ and was " company " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && company != "" && company !~ /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ { key=CSVFILENAME FS "company" FS  "pattern" FS "value should match: /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company_plot_number == "" { log_err("error"); print "Field company_plot_number in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && company_plot_number == "" { key=CSVFILENAME FS "company_plot_number" FS  "required" FS "value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company_plot_number != "" && length(company_plot_number) > 15 { log_err("error"); print "company_plot_number length in " CSVFILENAME " line " NR " should be less than 15 and was " length(company_plot_number) " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && company_plot_number != "" && length(company_plot_number) > 15 { key=CSVFILENAME FS "company_plot_number" FS  "maxLength" FS "max length is: 15" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_number && !is_numeric(tree_number) { log_err("error"); print "Field tree_number in " CSVFILENAME " line " NR " should be a numeric but was " tree_number " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && tree_number && !is_numeric(tree_number) { key=CSVFILENAME FS "tree_number" FS  "type" FS "max length is: 15" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_number == "" { log_err("error"); print "Field tree_number in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && tree_number == "" { key=CSVFILENAME FS "tree_number" FS  "required" FS "value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_number != "" && tree_number < 1 { log_err("error"); print "tree_number in " CSVFILENAME " line " NR " should be greater than 1 and was " tree_number " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && tree_number != "" && tree_number < 1 { key=CSVFILENAME FS "tree_number" FS  "minimum" FS "value should be greater than: 1" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_number != "" && tree_number > 9999999 { log_err("error"); print "tree_number in " CSVFILENAME " line " NR " should be less than 9999999 and was " tree_number " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && tree_number != "" && tree_number > 9999999 { key=CSVFILENAME FS "tree_number" FS  "maximum" FS "value should be less than: 9999999" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_label != "" && length(tree_label) > 15 { log_err("error"); print "tree_label length in " CSVFILENAME " line " NR " should be less than 15 and was " length(tree_label) " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && tree_label != "" && length(tree_label) > 15 { key=CSVFILENAME FS "tree_label" FS  "maxLength" FS "max length is: 15" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_location_id && !is_numeric(tree_location_id) { log_err("error"); print "Field tree_location_id in " CSVFILENAME " line " NR " should be a numeric but was " tree_location_id " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && tree_location_id && !is_numeric(tree_location_id) { key=CSVFILENAME FS "tree_location_id" FS  "type" FS "max length is: 15" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_location_id == "" { log_err("error"); print "Field tree_location_id in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && tree_location_id == "" { key=CSVFILENAME FS "tree_location_id" FS  "required" FS "value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_location_id != "" && tree_location_id !~ /^(0|1|2|3)$/ { log_err("error"); print "tree_location_id in " CSVFILENAME " line " NR " should match the following pattern /^(0|1|2|3)$/ and was " tree_location_id " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && tree_location_id != "" && tree_location_id !~ /^(0|1|2|3)$/ { key=CSVFILENAME FS "tree_location_id" FS  "pattern" FS "value should match: /^(0|1|2|3)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_origin && !is_numeric(tree_origin) { log_err("error"); print "Field tree_origin in " CSVFILENAME " line " NR " should be a numeric but was " tree_origin " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && tree_origin && !is_numeric(tree_origin) { key=CSVFILENAME FS "tree_origin" FS  "type" FS "value should match: /^(0|1|2|3)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_origin == "" { log_err("error"); print "Field tree_origin in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && tree_origin == "" { key=CSVFILENAME FS "tree_origin" FS  "required" FS "value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tree_origin != "" && tree_origin !~ /^(0|1|2|3|4|5|6|7|8|9|10)$/ { log_err("error"); print "tree_origin in " CSVFILENAME " line " NR " should match the following pattern /^(0|1|2|3|4|5|6|7|8|9|10)$/ and was " tree_origin " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && tree_origin != "" && tree_origin !~ /^(0|1|2|3|4|5|6|7|8|9|10)$/ { key=CSVFILENAME FS "tree_origin" FS  "pattern" FS "value should match: /^(0|1|2|3|4|5|6|7|8|9|10)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && sector_or_quarter != "" && length(sector_or_quarter) > 2 { log_err("error"); print "sector_or_quarter length in " CSVFILENAME " line " NR " should be less than 2 and was " length(sector_or_quarter) " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && sector_or_quarter != "" && length(sector_or_quarter) > 2 { key=CSVFILENAME FS "sector_or_quarter" FS  "maxLength" FS "max length is: 2" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && species == "" { log_err("error"); print "Field species in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && species == "" { key=CSVFILENAME FS "species" FS  "required" FS "value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && species != "" && species !~ /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ { log_err("error"); print "species in " CSVFILENAME " line " NR " should match the following pattern /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ and was " species " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && species != "" && species !~ /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ { key=CSVFILENAME FS "species" FS  "pattern" FS "value should match: /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && distance && !is_numeric(distance) { log_err("error"); print "Field distance in " CSVFILENAME " line " NR " should be a numeric but was " distance " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && distance && !is_numeric(distance) { key=CSVFILENAME FS "distance" FS  "type" FS "value should match: /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && distance != "" && distance < 0.01 { log_err("error"); print "distance in " CSVFILENAME " line " NR " should be greater than 0.01 and was " distance " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && distance != "" && distance < 0.01 { key=CSVFILENAME FS "distance" FS  "minimum" FS "value should be greater than: 0.01" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && distance != "" && distance > 100 { log_err("error"); print "distance in " CSVFILENAME " line " NR " should be less than 100 and was " distance " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && distance != "" && distance > 100 { key=CSVFILENAME FS "distance" FS  "maximum" FS "value should be less than: 100" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && azimuth && !is_numeric(azimuth) { log_err("error"); print "Field azimuth in " CSVFILENAME " line " NR " should be a numeric but was " azimuth " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && azimuth && !is_numeric(azimuth) { key=CSVFILENAME FS "azimuth" FS  "type" FS "value should be less than: 100" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && azimuth != "" && azimuth < 0 { log_err("error"); print "azimuth in " CSVFILENAME " line " NR " should be greater than 0 and was " azimuth " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && azimuth != "" && azimuth < 0 { key=CSVFILENAME FS "azimuth" FS  "minimum" FS "value should be greater than: 0" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && azimuth != "" && azimuth > 360 { log_err("error"); print "azimuth in " CSVFILENAME " line " NR " should be less than 360 and was " azimuth " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && azimuth != "" && azimuth > 360 { key=CSVFILENAME FS "azimuth" FS  "maximum" FS "value should be less than: 360" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && trees_comment != "" && length(trees_comment) > 250 { log_err("error"); print "trees_comment length in " CSVFILENAME " line " NR " should be less than 250 and was " length(trees_comment) " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && trees_comment != "" && length(trees_comment) > 250 { key=CSVFILENAME FS "trees_comment" FS  "maxLength" FS "max length is: 250" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 

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
    print "COPY trees (" addfields FS "source_row_index" FS $0 ") FROM stdin;"
}
action == "insert" && NR > 1 {
   record = addvals "\t" NR
   for (i = 1; i <= NF; i++) {
       record = record "\t" $i
   }
   print record
}
action == "table" && NR == 1 {
     print "CREATE TABLE IF NOT EXISTS trees (company ,company_plot_number ,tree_number ,tree_label ,tree_location_id ,tree_origin ,sector_or_quarter ,species ,distance ,azimuth ,trees_comment , CONSTRAINT trees_pkey PRIMARY KEY (company,company_plot_number,tree_number) , CONSTRAINT trees_plot_fkey FOREIGN KEY (company,company_plot_number) REFERENCES plot (company,company_plot_number) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION);"
}
action == "sanitize" { print }
# la fin
END {
    if (action == "validate:summary" && length(dupkeys) > 0) for (dup in dupkeys) { violation=CSVFILENAME FS "company|company_plot_number|tree_number" FS  "duplicate" FS dup " violates pkey" FS "error"; violations[violation] = dupkeys[dup]}
    if (action == "validate:summary") { if (length(violations) > 0) for (violation in violations) { print violation FS violations[violation]; } }
    if (action == "validate" && options["summary"] == "true") { print RS "violation summary: " RS "   counts:   " RS "      total: " err_count; print_cats(cats); }
}

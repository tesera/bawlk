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
    condition_code2=$22
    company_plot_number=$2
    cause2=$23
    measurement_number=$3
    severity2=$24
    tree_number=$4
    condition_code3=$25
    tree_type=$5
    cause3=$26
    dbh=$6
    severity3=$27
    dbh_height=$7
    trees_measurement_comment=$28
    rcd=$8
    rcd_height=$9
    height=$10
    crown_class=$11
    dbh_age=$12
    stump_age=$13
    stump_height=$14
    total_age=$15
    htlc=$16
    crown_diameter_ns=$17
    crown_diameter_ew=$18
    condition_code1=$19
    cause1=$20
    severity1=$21
    company=$1
}

# awk rules based on user csv ruleset
NR == 1 { headers="company|company_plot_number|measurement_number|tree_number|tree_type|dbh|dbh_height|rcd|rcd_height|height|crown_class|dbh_age|stump_age|stump_height|total_age|htlc|crown_diameter_ns|crown_diameter_ew|condition_code1|cause1|severity1|condition_code2|cause2|severity2|condition_code3|cause3|severity3|trees_measurement_comment"; if (!are_headers_valid(headers)) print "invalid headers in " FILENAME }
action == "validate" && NR > 1 && company == "" { log_err("warning"); print "Field company in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && company != "" && company !~ /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ { log_err("warning"); print "company in " FILENAME " line " NR " should match the following pattern /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ and was " company " " RS $0 RS; } 
action == "validate" && NR > 1 && company_plot_number == "" { log_err("warning"); print "Field company_plot_number in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && measurement_number && !is_numeric(measurement_number) { log_err("warning"); print "Field measurement_number in " FILENAME " line " NR " should be a numeric but was " measurement_number " " RS $0 RS; } 
action == "validate" && NR > 1 && measurement_number == "" { log_err("warning"); print "Field measurement_number in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && tree_number && !is_numeric(tree_number) { log_err("warning"); print "Field tree_number in " FILENAME " line " NR " should be a numeric but was " tree_number " " RS $0 RS; } 
action == "validate" && NR > 1 && tree_number != "" && tree_number < 1 { log_err("warning"); print "tree_number in " FILENAME " line " NR " should be greater than 1 and was " tree_number " " RS $0 RS; } 
action == "validate" && NR > 1 && tree_number != "" && tree_number > 999999 { log_err("warning"); print "tree_number in " FILENAME " line " NR " should be less than 999999 and was " tree_number " " RS $0 RS; } 
action == "validate" && NR > 1 && tree_type == "" { log_err("warning"); print "Field tree_type in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && tree_type != "" && tree_type !~ /^(T|S|PS|PO|B|R1|R2|R3|R4|R5|R6|R7|R8|R9|R10)$/ { log_err("warning"); print "tree_type in " FILENAME " line " NR " should match the following pattern /^(T|S|PS|PO|B|R1|R2|R3|R4|R5|R6|R7|R8|R9|R10)$/ and was " tree_type " " RS $0 RS; } 
action == "validate" && NR > 1 && dbh && !is_numeric(dbh) { log_err("warning"); print "Field dbh in " FILENAME " line " NR " should be a numeric but was " dbh " " RS $0 RS; } 
action == "validate" && NR > 1 && dbh != "" && dbh < 0.1 { log_err("warning"); print "dbh in " FILENAME " line " NR " should be greater than 0.1 and was " dbh " " RS $0 RS; } 
action == "validate" && NR > 1 && dbh != "" && dbh > 120 { log_err("warning"); print "dbh in " FILENAME " line " NR " should be less than 120 and was " dbh " " RS $0 RS; } 
action == "validate" && NR > 1 && dbh_height && !is_numeric(dbh_height) { log_err("warning"); print "Field dbh_height in " FILENAME " line " NR " should be a numeric but was " dbh_height " " RS $0 RS; } 
action == "validate" && NR > 1 && dbh_height != "" && dbh_height < 1.1 { log_err("warning"); print "dbh_height in " FILENAME " line " NR " should be greater than 1.1 and was " dbh_height " " RS $0 RS; } 
action == "validate" && NR > 1 && dbh_height != "" && dbh_height > 1.5 { log_err("warning"); print "dbh_height in " FILENAME " line " NR " should be less than 1.5 and was " dbh_height " " RS $0 RS; } 
action == "validate" && NR > 1 && rcd && !is_numeric(rcd) { log_err("warning"); print "Field rcd in " FILENAME " line " NR " should be a numeric but was " rcd " " RS $0 RS; } 
action == "validate" && NR > 1 && rcd != "" && rcd < 0.1 { log_err("warning"); print "rcd in " FILENAME " line " NR " should be greater than 0.1 and was " rcd " " RS $0 RS; } 
action == "validate" && NR > 1 && rcd != "" && rcd > 15 { log_err("warning"); print "rcd in " FILENAME " line " NR " should be less than 15 and was " rcd " " RS $0 RS; } 
action == "validate" && NR > 1 && rcd_height && !is_numeric(rcd_height) { log_err("warning"); print "Field rcd_height in " FILENAME " line " NR " should be a numeric but was " rcd_height " " RS $0 RS; } 
action == "validate" && NR > 1 && rcd_height != "" && rcd_height < 0 { log_err("warning"); print "rcd_height in " FILENAME " line " NR " should be greater than 0 and was " rcd_height " " RS $0 RS; } 
action == "validate" && NR > 1 && rcd_height != "" && rcd_height > 0.3 { log_err("warning"); print "rcd_height in " FILENAME " line " NR " should be less than 0.3 and was " rcd_height " " RS $0 RS; } 
action == "validate" && NR > 1 && height && !is_numeric(height) { log_err("warning"); print "Field height in " FILENAME " line " NR " should be a numeric but was " height " " RS $0 RS; } 
action == "validate" && NR > 1 && height != "" && height < 0 { log_err("warning"); print "height in " FILENAME " line " NR " should be greater than 0 and was " height " " RS $0 RS; } 
action == "validate" && NR > 1 && height != "" && height > 45 { log_err("warning"); print "height in " FILENAME " line " NR " should be less than 45 and was " height " " RS $0 RS; } 
action == "validate" && NR > 1 && crown_class == "" { log_err("warning"); print "Field crown_class in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && crown_class != "" && crown_class !~ /^(D|C|I|S|N)$/ { log_err("warning"); print "crown_class in " FILENAME " line " NR " should match the following pattern /^(D|C|I|S|N)$/ and was " crown_class " " RS $0 RS; } 
action == "validate" && NR > 1 && dbh_age && !is_numeric(dbh_age) { log_err("warning"); print "Field dbh_age in " FILENAME " line " NR " should be a numeric but was " dbh_age " " RS $0 RS; } 
action == "validate" && NR > 1 && dbh_age == "" { log_err("warning"); print "Field dbh_age in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && stump_age && !is_numeric(stump_age) { log_err("warning"); print "Field stump_age in " FILENAME " line " NR " should be a numeric but was " stump_age " " RS $0 RS; } 
action == "validate" && NR > 1 && stump_age != "" && stump_age < 1 { log_err("warning"); print "stump_age in " FILENAME " line " NR " should be greater than 1 and was " stump_age " " RS $0 RS; } 
action == "validate" && NR > 1 && stump_age != "" && stump_age > 350 { log_err("warning"); print "stump_age in " FILENAME " line " NR " should be less than 350 and was " stump_age " " RS $0 RS; } 
action == "validate" && NR > 1 && stump_height && !is_numeric(stump_height) { log_err("warning"); print "Field stump_height in " FILENAME " line " NR " should be a numeric but was " stump_height " " RS $0 RS; } 
action == "validate" && NR > 1 && stump_height != "" && stump_height < 0 { log_err("warning"); print "stump_height in " FILENAME " line " NR " should be greater than 0 and was " stump_height " " RS $0 RS; } 
action == "validate" && NR > 1 && stump_height != "" && stump_height > 0.3 { log_err("warning"); print "stump_height in " FILENAME " line " NR " should be less than 0.3 and was " stump_height " " RS $0 RS; } 
action == "validate" && NR > 1 && total_age && !is_numeric(total_age) { log_err("warning"); print "Field total_age in " FILENAME " line " NR " should be a numeric but was " total_age " " RS $0 RS; } 
action == "validate" && NR > 1 && total_age != "" && total_age < 1 { log_err("warning"); print "total_age in " FILENAME " line " NR " should be greater than 1 and was " total_age " " RS $0 RS; } 
action == "validate" && NR > 1 && total_age != "" && total_age > 350 { log_err("warning"); print "total_age in " FILENAME " line " NR " should be less than 350 and was " total_age " " RS $0 RS; } 
action == "validate" && NR > 1 && htlc && !is_numeric(htlc) { log_err("warning"); print "Field htlc in " FILENAME " line " NR " should be a numeric but was " htlc " " RS $0 RS; } 
action == "validate" && NR > 1 && htlc != "" && htlc < 0 { log_err("warning"); print "htlc in " FILENAME " line " NR " should be greater than 0 and was " htlc " " RS $0 RS; } 
action == "validate" && NR > 1 && htlc != "" && htlc > 45 { log_err("warning"); print "htlc in " FILENAME " line " NR " should be less than 45 and was " htlc " " RS $0 RS; } 
action == "validate" && NR > 1 && crown_diameter_ns && !is_numeric(crown_diameter_ns) { log_err("warning"); print "Field crown_diameter_ns in " FILENAME " line " NR " should be a numeric but was " crown_diameter_ns " " RS $0 RS; } 
action == "validate" && NR > 1 && crown_diameter_ns != "" && crown_diameter_ns < 1 { log_err("warning"); print "crown_diameter_ns in " FILENAME " line " NR " should be greater than 1 and was " crown_diameter_ns " " RS $0 RS; } 
action == "validate" && NR > 1 && crown_diameter_ns != "" && crown_diameter_ns > 20 { log_err("warning"); print "crown_diameter_ns in " FILENAME " line " NR " should be less than 20 and was " crown_diameter_ns " " RS $0 RS; } 
action == "validate" && NR > 1 && crown_diameter_ew && !is_numeric(crown_diameter_ew) { log_err("warning"); print "Field crown_diameter_ew in " FILENAME " line " NR " should be a numeric but was " crown_diameter_ew " " RS $0 RS; } 
action == "validate" && NR > 1 && crown_diameter_ew != "" && crown_diameter_ew < 1 { log_err("warning"); print "crown_diameter_ew in " FILENAME " line " NR " should be greater than 1 and was " crown_diameter_ew " " RS $0 RS; } 
action == "validate" && NR > 1 && crown_diameter_ew != "" && crown_diameter_ew > 20 { log_err("warning"); print "crown_diameter_ew in " FILENAME " line " NR " should be less than 20 and was " crown_diameter_ew " " RS $0 RS; } 
action == "validate" && NR > 1 && condition_code1 && !is_numeric(condition_code1) { log_err("warning"); print "Field condition_code1 in " FILENAME " line " NR " should be a numeric but was " condition_code1 " " RS $0 RS; } 
action == "validate" && NR > 1 && condition_code1 == "" { log_err("warning"); print "Field condition_code1 in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && condition_code1 != "" && condition_code1 !~ /^(0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16)$/ { log_err("warning"); print "condition_code1 in " FILENAME " line " NR " should match the following pattern /^(0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16)$/ and was " condition_code1 " " RS $0 RS; } 
action == "validate" && NR > 1 && cause1 && !is_numeric(cause1) { log_err("warning"); print "Field cause1 in " FILENAME " line " NR " should be a numeric but was " cause1 " " RS $0 RS; } 
action == "validate" && NR > 1 && cause1 == "" { log_err("warning"); print "Field cause1 in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && cause1 != "" && cause1 !~ /^(1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|99)$/ { log_err("warning"); print "cause1 in " FILENAME " line " NR " should match the following pattern /^(1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|99)$/ and was " cause1 " " RS $0 RS; } 
action == "validate" && NR > 1 && severity1 && !is_numeric(severity1) { log_err("warning"); print "Field severity1 in " FILENAME " line " NR " should be a numeric but was " severity1 " " RS $0 RS; } 
action == "validate" && NR > 1 && severity1 == "" { log_err("warning"); print "Field severity1 in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && severity1 != "" && severity1 !~ /^(1|2|3|9)$/ { log_err("warning"); print "severity1 in " FILENAME " line " NR " should match the following pattern /^(1|2|3|9)$/ and was " severity1 " " RS $0 RS; } 
action == "validate" && NR > 1 && condition_code2 && !is_numeric(condition_code2) { log_err("warning"); print "Field condition_code2 in " FILENAME " line " NR " should be a numeric but was " condition_code2 " " RS $0 RS; } 
action == "validate" && NR > 1 && condition_code2 == "" { log_err("warning"); print "Field condition_code2 in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && condition_code2 != "" && condition_code2 !~ /^(0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16)$/ { log_err("warning"); print "condition_code2 in " FILENAME " line " NR " should match the following pattern /^(0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16)$/ and was " condition_code2 " " RS $0 RS; } 
action == "validate" && NR > 1 && cause2 && !is_numeric(cause2) { log_err("warning"); print "Field cause2 in " FILENAME " line " NR " should be a numeric but was " cause2 " " RS $0 RS; } 
action == "validate" && NR > 1 && cause2 == "" { log_err("warning"); print "Field cause2 in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && cause2 != "" && cause2 !~ /^(1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|99)$/ { log_err("warning"); print "cause2 in " FILENAME " line " NR " should match the following pattern /^(1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|99)$/ and was " cause2 " " RS $0 RS; } 
action == "validate" && NR > 1 && severity2 && !is_numeric(severity2) { log_err("warning"); print "Field severity2 in " FILENAME " line " NR " should be a numeric but was " severity2 " " RS $0 RS; } 
action == "validate" && NR > 1 && severity2 == "" { log_err("warning"); print "Field severity2 in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && severity2 != "" && severity2 !~ /^(1|2|3|9)$/ { log_err("warning"); print "severity2 in " FILENAME " line " NR " should match the following pattern /^(1|2|3|9)$/ and was " severity2 " " RS $0 RS; } 
action == "validate" && NR > 1 && condition_code3 && !is_numeric(condition_code3) { log_err("warning"); print "Field condition_code3 in " FILENAME " line " NR " should be a numeric but was " condition_code3 " " RS $0 RS; } 
action == "validate" && NR > 1 && condition_code3 == "" { log_err("warning"); print "Field condition_code3 in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && condition_code3 != "" && condition_code3 !~ /^(0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16)$/ { log_err("warning"); print "condition_code3 in " FILENAME " line " NR " should match the following pattern /^(0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16)$/ and was " condition_code3 " " RS $0 RS; } 
action == "validate" && NR > 1 && cause3 && !is_numeric(cause3) { log_err("warning"); print "Field cause3 in " FILENAME " line " NR " should be a numeric but was " cause3 " " RS $0 RS; } 
action == "validate" && NR > 1 && cause3 == "" { log_err("warning"); print "Field cause3 in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && cause3 != "" && cause3 !~ /^(1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|99)$/ { log_err("warning"); print "cause3 in " FILENAME " line " NR " should match the following pattern /^(1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|99)$/ and was " cause3 " " RS $0 RS; } 
action == "validate" && NR > 1 && severity3 && !is_numeric(severity3) { log_err("warning"); print "Field severity3 in " FILENAME " line " NR " should be a numeric but was " severity3 " " RS $0 RS; } 
action == "validate" && NR > 1 && severity3 == "" { log_err("warning"); print "Field severity3 in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && severity3 != "" && severity3 !~ /^(1|2|3|9)$/ { log_err("warning"); print "severity3 in " FILENAME " line " NR " should match the following pattern /^(1|2|3|9)$/ and was " severity3 " " RS $0 RS; } 

# sanitize rules
action ~ /^(sanitize|insert)$/ && NR > 1 {
    if (stump_age == "") $13 = "-9999"
    if (height == "") $10 = "-9999"
    if (trees_measurement_comment == "") $28 = "NA"
    if (crown_diameter_ew == "") $18 = "-9999"
    if (dbh_age == "") $12 = "NA"
    if (tree_number == "") $4 = "-9999"
    if (rcd == "") $8 = "-9999"
    if (condition_code1 == "") $19 = "NA"
    if (total_age == "") $15 = "-9999"
    if (condition_code2 == "") $22 = "NA"
    if (condition_code3 == "") $25 = "NA"
    if (cause1 == "") $20 = "NA"
    if (dbh_height == "") $7 = "-9999"
    if (measurement_number == "") $3 = "NA"
    if (cause2 == "") $23 = "NA"
    if (cause3 == "") $26 = "NA"
    if (company_plot_number == "") $2 = "NA"
    if (crown_class == "") $11 = "NA"
    if (stump_height == "") $14 = "-9999"
    if (htlc == "") $16 = "-9999"
    if (crown_diameter_ns == "") $17 = "-9999"
    if (severity1 == "") $21 = "NA"
    if (dbh == "") $6 = "-9999"
    if (severity2 == "") $24 = "NA"
    if (company == "") $1 = "NA"
    if (severity3 == "") $27 = "NA"
    if (tree_type == "") $5 = "NA"
    if (rcd_height == "") $9 = "-9999"
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
     print "CREATE TABLE IF NOT EXISTS  (condition_code2 text,company_plot_number text,cause2 text,measurement_number text,severity2 text,tree_number numeric,condition_code3 text,tree_type text,cause3 text,dbh numeric,severity3 text,dbh_height numeric,trees_measurement_comment text,rcd numeric,rcd_height numeric,height numeric,crown_class text,dbh_age text,stump_age numeric,stump_height numeric,total_age numeric,htlc numeric,crown_diameter_ns numeric,crown_diameter_ew numeric,condition_code1 text,cause1 text,severity1 text,company text);"
}
action == "sanitize" { print }

# la fin
END {
    if (action == "insert") print "\\."
    if (action == "validate" && options["summary"] == "true") { print RS "violation summary: " RS "   counts:   " RS "      total: " err_count; print_cats(cats); }
}

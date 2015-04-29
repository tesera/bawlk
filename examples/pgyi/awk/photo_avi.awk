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
    struc_val=$22
    company_plot_number=$2
    origin=$23
    avi_version=$3
    tpr=$24
    polygon_number=$4
    photo_avi_layer_comment=$25
    year_photography=$5
    year_photo_call=$6
    layer_type=$7
    moist_reg=$8
    density=$9
    height=$10
    sp1=$11
    sp1_per=$12
    sp2=$13
    sp2_per=$14
    sp3=$15
    sp3_per=$16
    sp4=$17
    sp4_per=$18
    sp5=$19
    sp5_per=$20
    struc=$21
    company=$1
}

# awk rules based on user csv ruleset
NR == 1 && action == "validate" { headers="company|company_plot_number|avi_version|polygon_number|year_photography|year_photo_call|layer_type|moist_reg|density|height|sp1|sp1_per|sp2|sp2_per|sp3|sp3_per|sp4|sp4_per|sp5|sp5_per|struc|struc_val|origin|tpr|photo_avi_layer_comment"; if (!are_headers_valid(headers)) { gsub(/\|/, FS, headers); print RS "INVALID HEADERS IN " CSVFILENAME RS "WAS: " RS $0 RS "EXPECTED:" RS headers RS; exit 0; } }
NR == 1 && action == "validate:summary" { headers="company|company_plot_number|avi_version|polygon_number|year_photography|year_photo_call|layer_type|moist_reg|density|height|sp1|sp1_per|sp2|sp2_per|sp3|sp3_per|sp4|sp4_per|sp5|sp5_per|struc|struc_val|origin|tpr|photo_avi_layer_comment"; if (!are_headers_valid(headers)) { violations[CSVFILENAME FS "headers" FS  "names" FS "csv headers are invalid" FS "error"]=1; exit 0; } }
action ~ /validate/ && NR > 1 { pkey=company "-" company_plot_number "-" polygon_number "-" year_photography "-" layer_type; if(keys[pkey]) { if (dupkeys[pkey]) dupkeys[pkey]++; else dupkeys[pkey] = 1 } else { keys[pkey] = NR } }
action == "validate" && NR > 1 && company == "" { log_err("error"); print "Field company in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && company == "" { key=CSVFILENAME FS "company" FS  "required" FS "value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company != "" && company !~ /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ { log_err("error"); print "company in " CSVFILENAME " line " NR " should match the following pattern /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ and was " company " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && company != "" && company !~ /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ { key=CSVFILENAME FS "company" FS  "pattern" FS "value should match: /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company_plot_number == "" { log_err("error"); print "Field company_plot_number in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && company_plot_number == "" { key=CSVFILENAME FS "company_plot_number" FS  "required" FS "value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && company_plot_number != "" && length(company_plot_number) > 15 { log_err("error"); print "company_plot_number length in " CSVFILENAME " line " NR " should be less than 15 and was " length(company_plot_number) " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && company_plot_number != "" && length(company_plot_number) > 15 { key=CSVFILENAME FS "company_plot_number" FS  "maxLength" FS "max length is: 15" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && avi_version != "" && avi_version !~ /^(AVI10|AVI21|AVI211|AVI22)$/ { log_err("error"); print "avi_version in " CSVFILENAME " line " NR " should match the following pattern /^(AVI10|AVI21|AVI211|AVI22)$/ and was " avi_version " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && avi_version != "" && avi_version !~ /^(AVI10|AVI21|AVI211|AVI22)$/ { key=CSVFILENAME FS "avi_version" FS  "pattern" FS "value should match: /^(AVI10|AVI21|AVI211|AVI22)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && polygon_number && !is_numeric(polygon_number) { log_err("error"); print "Field polygon_number in " CSVFILENAME " line " NR " should be a numeric but was " polygon_number " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && polygon_number && !is_numeric(polygon_number) { key=CSVFILENAME FS "polygon_number" FS  "type" FS "value should match: /^(AVI10|AVI21|AVI211|AVI22)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && polygon_number == "" { log_err("error"); print "Field polygon_number in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && polygon_number == "" { key=CSVFILENAME FS "polygon_number" FS  "required" FS "value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && polygon_number != "" && polygon_number < 1 { log_err("error"); print "polygon_number in " CSVFILENAME " line " NR " should be greater than 1 and was " polygon_number " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && polygon_number != "" && polygon_number < 1 { key=CSVFILENAME FS "polygon_number" FS  "minimum" FS "value should be greater than: 1" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && polygon_number != "" && polygon_number > 9999999999 { log_err("error"); print "polygon_number in " CSVFILENAME " line " NR " should be less than 9999999999 and was " polygon_number " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && polygon_number != "" && polygon_number > 9999999999 { key=CSVFILENAME FS "polygon_number" FS  "maximum" FS "value should be less than: 9999999999" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && year_photography && !is_numeric(year_photography) { log_err("error"); print "Field year_photography in " CSVFILENAME " line " NR " should be a numeric but was " year_photography " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && year_photography && !is_numeric(year_photography) { key=CSVFILENAME FS "year_photography" FS  "type" FS "value should be less than: 9999999999" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && year_photography == "" { log_err("error"); print "Field year_photography in " CSVFILENAME " line " NR " is required" RS $0 RS; } 
action == "validate:summary" && NR > 1 && year_photography == "" { key=CSVFILENAME FS "year_photography" FS  "required" FS "value is required but was empty" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && year_photography != "" && year_photography < 1900 { log_err("error"); print "year_photography in " CSVFILENAME " line " NR " should be greater than 1900 and was " year_photography " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && year_photography != "" && year_photography < 1900 { key=CSVFILENAME FS "year_photography" FS  "minimum" FS "value should be greater than: 1900" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && year_photography != "" && year_photography > 2050 { log_err("error"); print "year_photography in " CSVFILENAME " line " NR " should be less than 2050 and was " year_photography " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && year_photography != "" && year_photography > 2050 { key=CSVFILENAME FS "year_photography" FS  "maximum" FS "value should be less than: 2050" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && year_photo_call && !is_numeric(year_photo_call) { log_err("error"); print "Field year_photo_call in " CSVFILENAME " line " NR " should be a numeric but was " year_photo_call " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && year_photo_call && !is_numeric(year_photo_call) { key=CSVFILENAME FS "year_photo_call" FS  "type" FS "value should be less than: 2050" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && year_photo_call != "" && year_photo_call < 1900 { log_err("error"); print "year_photo_call in " CSVFILENAME " line " NR " should be greater than 1900 and was " year_photo_call " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && year_photo_call != "" && year_photo_call < 1900 { key=CSVFILENAME FS "year_photo_call" FS  "minimum" FS "value should be greater than: 1900" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && year_photo_call != "" && year_photo_call > 2050 { log_err("error"); print "year_photo_call in " CSVFILENAME " line " NR " should be less than 2050 and was " year_photo_call " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && year_photo_call != "" && year_photo_call > 2050 { key=CSVFILENAME FS "year_photo_call" FS  "maximum" FS "value should be less than: 2050" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && layer_type && !is_numeric(layer_type) { log_err("error"); print "Field layer_type in " CSVFILENAME " line " NR " should be a numeric but was " layer_type " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && layer_type && !is_numeric(layer_type) { key=CSVFILENAME FS "layer_type" FS  "type" FS "value should be less than: 2050" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && layer_type != "" && layer_type !~ /^(1|2|3|4|5)$/ { log_err("error"); print "layer_type in " CSVFILENAME " line " NR " should match the following pattern /^(1|2|3|4|5)$/ and was " layer_type " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && layer_type != "" && layer_type !~ /^(1|2|3|4|5)$/ { key=CSVFILENAME FS "layer_type" FS  "pattern" FS "value should match: /^(1|2|3|4|5)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && moist_reg != "" && moist_reg !~ /^(d|m|w|a)$/ { log_err("error"); print "moist_reg in " CSVFILENAME " line " NR " should match the following pattern /^(d|m|w|a)$/ and was " moist_reg " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && moist_reg != "" && moist_reg !~ /^(d|m|w|a)$/ { key=CSVFILENAME FS "moist_reg" FS  "pattern" FS "value should match: /^(d|m|w|a)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && density != "" && density !~ /^(A|B|C|D)$/ { log_err("error"); print "density in " CSVFILENAME " line " NR " should match the following pattern /^(A|B|C|D)$/ and was " density " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && density != "" && density !~ /^(A|B|C|D)$/ { key=CSVFILENAME FS "density" FS  "pattern" FS "value should match: /^(A|B|C|D)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && height && !is_numeric(height) { log_err("error"); print "Field height in " CSVFILENAME " line " NR " should be a numeric but was " height " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && height && !is_numeric(height) { key=CSVFILENAME FS "height" FS  "type" FS "value should match: /^(A|B|C|D)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && height != "" && height < 0 { log_err("error"); print "height in " CSVFILENAME " line " NR " should be greater than 0 and was " height " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && height != "" && height < 0 { key=CSVFILENAME FS "height" FS  "minimum" FS "value should be greater than: 0" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && height != "" && height > 50 { log_err("error"); print "height in " CSVFILENAME " line " NR " should be less than 50 and was " height " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && height != "" && height > 50 { key=CSVFILENAME FS "height" FS  "maximum" FS "value should be less than: 50" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && sp1 != "" && sp1 !~ /^(A|Aw|Pb|Bw|Ax|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|No)$/ { log_err("error"); print "sp1 in " CSVFILENAME " line " NR " should match the following pattern /^(A|Aw|Pb|Bw|Ax|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|No)$/ and was " sp1 " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && sp1 != "" && sp1 !~ /^(A|Aw|Pb|Bw|Ax|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|No)$/ { key=CSVFILENAME FS "sp1" FS  "pattern" FS "value should match: /^(A|Aw|Pb|Bw|Ax|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|No)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && sp1_per && !is_numeric(sp1_per) { log_err("error"); print "Field sp1_per in " CSVFILENAME " line " NR " should be a numeric but was " sp1_per " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && sp1_per && !is_numeric(sp1_per) { key=CSVFILENAME FS "sp1_per" FS  "type" FS "value should match: /^(A|Aw|Pb|Bw|Ax|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|No)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && sp1_per != "" && sp1_per !~ /^(0|2|3|4|5|6|7|8|9|10)$/ { log_err("error"); print "sp1_per in " CSVFILENAME " line " NR " should match the following pattern /^(0|2|3|4|5|6|7|8|9|10)$/ and was " sp1_per " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && sp1_per != "" && sp1_per !~ /^(0|2|3|4|5|6|7|8|9|10)$/ { key=CSVFILENAME FS "sp1_per" FS  "pattern" FS "value should match: /^(0|2|3|4|5|6|7|8|9|10)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && sp2 != "" && sp2 !~ /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ { log_err("error"); print "sp2 in " CSVFILENAME " line " NR " should match the following pattern /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ and was " sp2 " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && sp2 != "" && sp2 !~ /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ { key=CSVFILENAME FS "sp2" FS  "pattern" FS "value should match: /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && sp2_per && !is_numeric(sp2_per) { log_err("error"); print "Field sp2_per in " CSVFILENAME " line " NR " should be a numeric but was " sp2_per " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && sp2_per && !is_numeric(sp2_per) { key=CSVFILENAME FS "sp2_per" FS  "type" FS "value should match: /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && sp2_per != "" && sp2_per !~ /^(0|1|2|3|4|5)$/ { log_err("error"); print "sp2_per in " CSVFILENAME " line " NR " should match the following pattern /^(0|1|2|3|4|5)$/ and was " sp2_per " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && sp2_per != "" && sp2_per !~ /^(0|1|2|3|4|5)$/ { key=CSVFILENAME FS "sp2_per" FS  "pattern" FS "value should match: /^(0|1|2|3|4|5)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && sp3 != "" && sp3 !~ /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ { log_err("error"); print "sp3 in " CSVFILENAME " line " NR " should match the following pattern /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ and was " sp3 " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && sp3 != "" && sp3 !~ /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ { key=CSVFILENAME FS "sp3" FS  "pattern" FS "value should match: /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && sp3_per && !is_numeric(sp3_per) { log_err("error"); print "Field sp3_per in " CSVFILENAME " line " NR " should be a numeric but was " sp3_per " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && sp3_per && !is_numeric(sp3_per) { key=CSVFILENAME FS "sp3_per" FS  "type" FS "value should match: /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && sp3_per != "" && sp3_per !~ /^(0|1|2|3)$/ { log_err("error"); print "sp3_per in " CSVFILENAME " line " NR " should match the following pattern /^(0|1|2|3)$/ and was " sp3_per " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && sp3_per != "" && sp3_per !~ /^(0|1|2|3)$/ { key=CSVFILENAME FS "sp3_per" FS  "pattern" FS "value should match: /^(0|1|2|3)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && sp4 != "" && sp4 !~ /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ { log_err("error"); print "sp4 in " CSVFILENAME " line " NR " should match the following pattern /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ and was " sp4 " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && sp4 != "" && sp4 !~ /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ { key=CSVFILENAME FS "sp4" FS  "pattern" FS "value should match: /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && sp4_per && !is_numeric(sp4_per) { log_err("error"); print "Field sp4_per in " CSVFILENAME " line " NR " should be a numeric but was " sp4_per " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && sp4_per && !is_numeric(sp4_per) { key=CSVFILENAME FS "sp4_per" FS  "type" FS "value should match: /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && sp4_per != "" && sp4_per !~ /^(0|1|2)$/ { log_err("error"); print "sp4_per in " CSVFILENAME " line " NR " should match the following pattern /^(0|1|2)$/ and was " sp4_per " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && sp4_per != "" && sp4_per !~ /^(0|1|2)$/ { key=CSVFILENAME FS "sp4_per" FS  "pattern" FS "value should match: /^(0|1|2)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && sp5 != "" && sp5 !~ /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ { log_err("error"); print "sp5 in " CSVFILENAME " line " NR " should match the following pattern /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ and was " sp5 " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && sp5 != "" && sp5 !~ /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/ { key=CSVFILENAME FS "sp5" FS  "pattern" FS "value should match: /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && sp5_per && !is_numeric(sp5_per) { log_err("error"); print "Field sp5_per in " CSVFILENAME " line " NR " should be a numeric but was " sp5_per " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && sp5_per && !is_numeric(sp5_per) { key=CSVFILENAME FS "sp5_per" FS  "type" FS "value should match: /^(A|Aw|Pb|Bw|Ax|Dd|Dc|P|Pl|Pw|Pa|Pf|Pj|Px|Sw|Se|Sb|Sx|Fb|Fa|Fd|Lt|Lw|La|Ls|Du|Ms|No)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && sp5_per != "" && sp5_per !~ /^(0|1|2)$/ { log_err("error"); print "sp5_per in " CSVFILENAME " line " NR " should match the following pattern /^(0|1|2)$/ and was " sp5_per " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && sp5_per != "" && sp5_per !~ /^(0|1|2)$/ { key=CSVFILENAME FS "sp5_per" FS  "pattern" FS "value should match: /^(0|1|2)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && struc != "" && struc !~ /^(S|M|C|H)$/ { log_err("error"); print "struc in " CSVFILENAME " line " NR " should match the following pattern /^(S|M|C|H)$/ and was " struc " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && struc != "" && struc !~ /^(S|M|C|H)$/ { key=CSVFILENAME FS "struc" FS  "pattern" FS "value should match: /^(S|M|C|H)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && struc_val && !is_numeric(struc_val) { log_err("error"); print "Field struc_val in " CSVFILENAME " line " NR " should be a numeric but was " struc_val " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && struc_val && !is_numeric(struc_val) { key=CSVFILENAME FS "struc_val" FS  "type" FS "value should match: /^(S|M|C|H)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && struc_val != "" && struc_val !~ /^(0|1|2|3|4|5|6|7|8|9)$/ { log_err("error"); print "struc_val in " CSVFILENAME " line " NR " should match the following pattern /^(0|1|2|3|4|5|6|7|8|9)$/ and was " struc_val " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && struc_val != "" && struc_val !~ /^(0|1|2|3|4|5|6|7|8|9)$/ { key=CSVFILENAME FS "struc_val" FS  "pattern" FS "value should match: /^(0|1|2|3|4|5|6|7|8|9)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && origin && !is_numeric(origin) { log_err("error"); print "Field origin in " CSVFILENAME " line " NR " should be a numeric but was " origin " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && origin && !is_numeric(origin) { key=CSVFILENAME FS "origin" FS  "type" FS "value should match: /^(0|1|2|3|4|5|6|7|8|9)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && origin != "" && origin < 0 { log_err("error"); print "origin in " CSVFILENAME " line " NR " should be greater than 0 and was " origin " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && origin != "" && origin < 0 { key=CSVFILENAME FS "origin" FS  "minimum" FS "value should be greater than: 0" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && origin != "" && origin > 2050 { log_err("error"); print "origin in " CSVFILENAME " line " NR " should be less than 2050 and was " origin " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && origin != "" && origin > 2050 { key=CSVFILENAME FS "origin" FS  "maximum" FS "value should be less than: 2050" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && tpr != "" && tpr !~ /^(U|F|M|G)$/ { log_err("error"); print "tpr in " CSVFILENAME " line " NR " should match the following pattern /^(U|F|M|G)$/ and was " tpr " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && tpr != "" && tpr !~ /^(U|F|M|G)$/ { key=CSVFILENAME FS "tpr" FS  "pattern" FS "value should match: /^(U|F|M|G)$/" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 
action == "validate" && NR > 1 && photo_avi_layer_comment != "" && length(photo_avi_layer_comment) > 250 { log_err("error"); print "photo_avi_layer_comment length in " CSVFILENAME " line " NR " should be less than 250 and was " length(photo_avi_layer_comment) " " RS $0 RS; } 
action == "validate:summary" && NR > 1 && photo_avi_layer_comment != "" && length(photo_avi_layer_comment) > 250 { key=CSVFILENAME FS "photo_avi_layer_comment" FS  "maxLength" FS "max length is: 250" FS "error"; if(!violations[key]) { violations[key]=0; } violations[key]++; } 

# sanitize rules
action ~ /^(sanitize|insert)$/ && NR > 1 {
    if (struc == "") $21 = "NA"
    if (height == "") $10 = "NA"
    if (photo_avi_layer_comment == "") $25 = "NA"
    if (origin == "") $23 = "NA"
    if (sp5_per == "") $20 = "NA"
    if (tpr == "") $24 = "NA"
    if (polygon_number == "") $4 = "NA"
    if (year_photography == "") $5 = "NA"
    if (avi_version == "") $3 = "NA"
    if (sp3_per == "") $16 = "NA"
    if (sp1_per == "") $12 = "NA"
    if (layer_type == "") $7 = "NA"
    if (company_plot_number == "") $2 = "NA"
    if (density == "") $9 = "NA"
    if (year_photo_call == "") $6 = "NA"
    if (sp1 == "") $11 = "NA"
    if (sp4_per == "") $18 = "NA"
    if (sp2 == "") $13 = "NA"
    if (sp3 == "") $15 = "NA"
    if (sp4 == "") $17 = "NA"
    if (sp5 == "") $19 = "NA"
    if (moist_reg == "") $8 = "NA"
    if (company == "") $1 = "NA"
    if (struc_val == "") $22 = "NA"
    if (sp2_per == "") $14 = "NA"
}

# action handlers
action == "insert" && NR == 1 {
    print "COPY photo_avi_layer (" addfields FS "source_row_index" FS $0 ") FROM stdin;"
}
action == "insert" && NR > 1 {
    gsub(",", "\t");
    print addvals "\t" NR "\t" $0;
}
action == "table" && NR == 1 {
     print "CREATE TABLE IF NOT EXISTS photo_avi_layer (company ,company_plot_number ,avi_version ,polygon_number ,year_photography ,year_photo_call ,layer_type ,moist_reg ,density ,height ,sp1 ,sp1_per ,sp2 ,sp2_per ,sp3 ,sp3_per ,sp4 ,sp4_per ,sp5 ,sp5_per ,struc ,struc_val ,origin ,tpr ,photo_avi_layer_comment , CONSTRAINT photo_avi_layer_pkey PRIMARY KEY (company,company_plot_number,polygon_number,year_photography,layer_type) , CONSTRAINT photo_avi_layer_plot_fkey FOREIGN KEY (company,company_plot_number) REFERENCES plot (company,company_plot_number) MATCH FULL ON UPDATE CASCADE ON DELETE NO ACTION);"
}
action == "sanitize" { print }
# la fin
END {
    if (action == "validate:summary" && length(dupkeys) > 0) for (dup in dupkeys) { violation=CSVFILENAME FS "company|company_plot_number|polygon_number|year_photography|layer_type" FS  "duplicate" FS dup " violates pkey" FS "error"; violations[violation] = dupkeys[dup]}
    if (action == "validate:summary") { if (length(violations) > 0) for (violation in violations) { print violation FS violations[violation]; } }
    if (action == "validate" && options["summary"] == "true") { print RS "violation summary: " RS "   counts:   " RS "      total: " err_count; print_cats(cats); }
}

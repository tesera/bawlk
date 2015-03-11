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
    datum=$22
    company_plot_number=$2
    latitude=$23
    company_stand_number=$3
    longitude=$24
    establishment_year=$4
    natural_subregion=$25
    establishment_month=$5
    ecosite_guide=$26
    establishment_day=$6
    ecosite=$27
    fmu=$7
    ecosite_phase=$28
    fma=$8
    plot_comment=$29
    ats_township=$9
    ats_range=$10
    ats_meridian=$11
    ats_section=$12
    opening_number=$13
    sampling_unit_number=$14
    topographic_position=$15
    elevation=$16
    slope=$17
    aspect=$18
    x_coord=$19
    y_coord=$20
    utm_zone=$21
    company=$1
}

# awk rules based on user csv ruleset
NR == 1 { headers="company|company_plot_number|company_stand_number|establishment_year|establishment_month|establishment_day|fmu|fma|ats_township|ats_range|ats_meridian|ats_section|opening_number|sampling_unit_number|topographic_position|elevation|slope|aspect|x_coord|y_coord|utm_zone|datum|latitude|longitude|natural_subregion|ecosite_guide|ecosite|ecosite_phase|plot_comment"; if (!are_headers_valid(headers)) print "invalid headers in " FILENAME }
action == "validate" && NR > 1 && company == "" { log_err("warning"); print "Field company in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && company != "" && company !~ /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ { log_err("warning"); print "company in " FILENAME " line " NR " should match the following pattern /^(AINS|GOA|APLY|ALPC|ANC|BLUE|CFPL|CFS|DAIS|FOFP|BUCH|MDFP|MWWC|SLPC|SPRA|SUND|SFPI|HLFP|TOLK|TOSL|UOA|VAND|WFML|WYGP|WYPM|UNKN|HPFP)$/ and was " company " " RS $0 RS; } 
action == "validate" && NR > 1 && company_plot_number == "" { log_err("warning"); print "Field company_plot_number in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && !is_unique(company_plot_number) { log_err("warning"); print "Field company_plot_number in " FILENAME " line " NR " is a duplicate and should be unique" RS $0 RS; } 
action == "validate" && NR > 1 && establishment_year && !is_numeric(establishment_year) { log_err("warning"); print "Field establishment_year in " FILENAME " line " NR " should be a numeric but was " establishment_year " " RS $0 RS; } 
action == "validate" && NR > 1 && establishment_year == "" { log_err("warning"); print "Field establishment_year in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && establishment_year != "" && establishment_year < 1900 { log_err("warning"); print "establishment_year in " FILENAME " line " NR " should be greater than 1900 and was " establishment_year " " RS $0 RS; } 
action == "validate" && NR > 1 && establishment_year != "" && establishment_year > 2050 { log_err("warning"); print "establishment_year in " FILENAME " line " NR " should be less than 2050 and was " establishment_year " " RS $0 RS; } 
action == "validate" && NR > 1 && establishment_month && !is_numeric(establishment_month) { log_err("warning"); print "Field establishment_month in " FILENAME " line " NR " should be a numeric but was " establishment_month " " RS $0 RS; } 
action == "validate" && NR > 1 && establishment_month != "" && establishment_month < 1 { log_err("warning"); print "establishment_month in " FILENAME " line " NR " should be greater than 1 and was " establishment_month " " RS $0 RS; } 
action == "validate" && NR > 1 && establishment_month != "" && establishment_month > 12 { log_err("warning"); print "establishment_month in " FILENAME " line " NR " should be less than 12 and was " establishment_month " " RS $0 RS; } 
action == "validate" && NR > 1 && establishment_day && !is_numeric(establishment_day) { log_err("warning"); print "Field establishment_day in " FILENAME " line " NR " should be a numeric but was " establishment_day " " RS $0 RS; } 
action == "validate" && NR > 1 && establishment_day != "" && establishment_day < 1 { log_err("warning"); print "establishment_day in " FILENAME " line " NR " should be greater than 1 and was " establishment_day " " RS $0 RS; } 
action == "validate" && NR > 1 && establishment_day != "" && establishment_day > 31 { log_err("warning"); print "establishment_day in " FILENAME " line " NR " should be less than 31 and was " establishment_day " " RS $0 RS; } 
action == "validate" && NR > 1 && fmu != "" && fmu !~ /^(A10|A11|A12|A13|A14|A4|A5|A6|A7|A8|A9|B10|B11|B9|BO1|BO2|C4|C5|CO1|CO2|E1|E10|E11|E2|E3|E4|E5|E6|E7|E8|E9|EO1|F1|F10|F11|F14|F20|F21|F23|F24|F25|FO1|G1|G10|G11|G12|G13|G14|G16|G2|G3|G4|G5|G6|G7|G8|G9|GO1|GO2|GO3|GO4|H1|L1|L11|L2|L3|L8|L9|LO1|M1|M10|M3|M4|M7|M9|NA|P1|P10|P11|P13|P3|P4|P5|P6|P7|P8|P9|PO1|PO2|PO3|R1|R10|R11|R13|R2|R2U|R3|R4|R4Y|RO1|S10|S11|S14|S15|S16|S17|S18|S19|S20|S21|S22|S7|S9|SO1|SO2|W1|W10|W11|W13|W14|W15|W2|W3|W4|W5|W6|W8|WO1|WO2|WO3|E14)$/ { log_err("warning"); print "fmu in " FILENAME " line " NR " should match the following pattern /^(A10|A11|A12|A13|A14|A4|A5|A6|A7|A8|A9|B10|B11|B9|BO1|BO2|C4|C5|CO1|CO2|E1|E10|E11|E2|E3|E4|E5|E6|E7|E8|E9|EO1|F1|F10|F11|F14|F20|F21|F23|F24|F25|FO1|G1|G10|G11|G12|G13|G14|G16|G2|G3|G4|G5|G6|G7|G8|G9|GO1|GO2|GO3|GO4|H1|L1|L11|L2|L3|L8|L9|LO1|M1|M10|M3|M4|M7|M9|NA|P1|P10|P11|P13|P3|P4|P5|P6|P7|P8|P9|PO1|PO2|PO3|R1|R10|R11|R13|R2|R2U|R3|R4|R4Y|RO1|S10|S11|S14|S15|S16|S17|S18|S19|S20|S21|S22|S7|S9|SO1|SO2|W1|W10|W11|W13|W14|W15|W2|W3|W4|W5|W6|W8|WO1|WO2|WO3|E14)$/ and was " fmu " " RS $0 RS; } 
action == "validate" && NR > 1 && ats_township && !is_numeric(ats_township) { log_err("warning"); print "Field ats_township in " FILENAME " line " NR " should be a numeric but was " ats_township " " RS $0 RS; } 
action == "validate" && NR > 1 && ats_township == "" { log_err("warning"); print "Field ats_township in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && ats_township != "" && ats_township < 1 { log_err("warning"); print "ats_township in " FILENAME " line " NR " should be greater than 1 and was " ats_township " " RS $0 RS; } 
action == "validate" && NR > 1 && ats_township != "" && ats_township > 126 { log_err("warning"); print "ats_township in " FILENAME " line " NR " should be less than 126 and was " ats_township " " RS $0 RS; } 
action == "validate" && NR > 1 && ats_range && !is_numeric(ats_range) { log_err("warning"); print "Field ats_range in " FILENAME " line " NR " should be a numeric but was " ats_range " " RS $0 RS; } 
action == "validate" && NR > 1 && ats_range == "" { log_err("warning"); print "Field ats_range in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && ats_range != "" && ats_range < 1 { log_err("warning"); print "ats_range in " FILENAME " line " NR " should be greater than 1 and was " ats_range " " RS $0 RS; } 
action == "validate" && NR > 1 && ats_range != "" && ats_range > 26 { log_err("warning"); print "ats_range in " FILENAME " line " NR " should be less than 26 and was " ats_range " " RS $0 RS; } 
action == "validate" && NR > 1 && ats_meridian && !is_numeric(ats_meridian) { log_err("warning"); print "Field ats_meridian in " FILENAME " line " NR " should be a numeric but was " ats_meridian " " RS $0 RS; } 
action == "validate" && NR > 1 && ats_meridian == "" { log_err("warning"); print "Field ats_meridian in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && ats_meridian != "" && ats_meridian < 4 { log_err("warning"); print "ats_meridian in " FILENAME " line " NR " should be greater than 4 and was " ats_meridian " " RS $0 RS; } 
action == "validate" && NR > 1 && ats_meridian != "" && ats_meridian > 6 { log_err("warning"); print "ats_meridian in " FILENAME " line " NR " should be less than 6 and was " ats_meridian " " RS $0 RS; } 
action == "validate" && NR > 1 && ats_section && !is_numeric(ats_section) { log_err("warning"); print "Field ats_section in " FILENAME " line " NR " should be a numeric but was " ats_section " " RS $0 RS; } 
action == "validate" && NR > 1 && ats_section == "" { log_err("warning"); print "Field ats_section in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && ats_section != "" && ats_section < 1 { log_err("warning"); print "ats_section in " FILENAME " line " NR " should be greater than 1 and was " ats_section " " RS $0 RS; } 
action == "validate" && NR > 1 && ats_section != "" && ats_section > 36 { log_err("warning"); print "ats_section in " FILENAME " line " NR " should be less than 36 and was " ats_section " " RS $0 RS; } 
action == "validate" && NR > 1 && topographic_position && !is_numeric(topographic_position) { log_err("warning"); print "Field topographic_position in " FILENAME " line " NR " should be a numeric but was " topographic_position " " RS $0 RS; } 
action == "validate" && NR > 1 && topographic_position != "" && topographic_position !~ /^(1|2|3|4|5|6|7)$/ { log_err("warning"); print "topographic_position in " FILENAME " line " NR " should match the following pattern /^(1|2|3|4|5|6|7)$/ and was " topographic_position " " RS $0 RS; } 
action == "validate" && NR > 1 && elevation && !is_numeric(elevation) { log_err("warning"); print "Field elevation in " FILENAME " line " NR " should be a numeric but was " elevation " " RS $0 RS; } 
action == "validate" && NR > 1 && elevation != "" && elevation < 0 { log_err("warning"); print "elevation in " FILENAME " line " NR " should be greater than 0 and was " elevation " " RS $0 RS; } 
action == "validate" && NR > 1 && elevation != "" && elevation > 3747 { log_err("warning"); print "elevation in " FILENAME " line " NR " should be less than 3747 and was " elevation " " RS $0 RS; } 
action == "validate" && NR > 1 && slope && !is_numeric(slope) { log_err("warning"); print "Field slope in " FILENAME " line " NR " should be a numeric but was " slope " " RS $0 RS; } 
action == "validate" && NR > 1 && slope != "" && slope < 0 { log_err("warning"); print "slope in " FILENAME " line " NR " should be greater than 0 and was " slope " " RS $0 RS; } 
action == "validate" && NR > 1 && slope != "" && slope > 200 { log_err("warning"); print "slope in " FILENAME " line " NR " should be less than 200 and was " slope " " RS $0 RS; } 
action == "validate" && NR > 1 && aspect != "" && aspect !~ /^(N|E|S|W|NE|SE|SW|NW|NA)$/ { log_err("warning"); print "aspect in " FILENAME " line " NR " should match the following pattern /^(N|E|S|W|NE|SE|SW|NW|NA)$/ and was " aspect " " RS $0 RS; } 
action == "validate" && NR > 1 && x_coord && !is_numeric(x_coord) { log_err("warning"); print "Field x_coord in " FILENAME " line " NR " should be a numeric but was " x_coord " " RS $0 RS; } 
action == "validate" && NR > 1 && x_coord != "" && x_coord < -111700 { log_err("warning"); print "x_coord in " FILENAME " line " NR " should be greater than -111700 and was " x_coord " " RS $0 RS; } 
action == "validate" && NR > 1 && x_coord != "" && x_coord > -1030400 { log_err("warning"); print "x_coord in " FILENAME " line " NR " should be less than -1030400 and was " x_coord " " RS $0 RS; } 
action == "validate" && NR > 1 && y_coord && !is_numeric(y_coord) { log_err("warning"); print "Field y_coord in " FILENAME " line " NR " should be a numeric but was " y_coord " " RS $0 RS; } 
action == "validate" && NR > 1 && y_coord != "" && y_coord < 5643600 { log_err("warning"); print "y_coord in " FILENAME " line " NR " should be greater than 5643600 and was " y_coord " " RS $0 RS; } 
action == "validate" && NR > 1 && y_coord != "" && y_coord > 6702500 { log_err("warning"); print "y_coord in " FILENAME " line " NR " should be less than 6702500 and was " y_coord " " RS $0 RS; } 
action == "validate" && NR > 1 && utm_zone == "" { log_err("warning"); print "Field utm_zone in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && utm_zone != "" && utm_zone !~ /^(UTM11|UTM12)$/ { log_err("warning"); print "utm_zone in " FILENAME " line " NR " should match the following pattern /^(UTM11|UTM12)$/ and was " utm_zone " " RS $0 RS; } 
action == "validate" && NR > 1 && datum == "" { log_err("warning"); print "Field datum in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && datum != "" && datum !~ /^(NAD27|NAD83)$/ { log_err("warning"); print "datum in " FILENAME " line " NR " should match the following pattern /^(NAD27|NAD83)$/ and was " datum " " RS $0 RS; } 
action == "validate" && NR > 1 && latitude && !is_numeric(latitude) { log_err("warning"); print "Field latitude in " FILENAME " line " NR " should be a numeric but was " latitude " " RS $0 RS; } 
action == "validate" && NR > 1 && latitude != "" && latitude < 49 { log_err("warning"); print "latitude in " FILENAME " line " NR " should be greater than 49 and was " latitude " " RS $0 RS; } 
action == "validate" && NR > 1 && latitude != "" && latitude > 60 { log_err("warning"); print "latitude in " FILENAME " line " NR " should be less than 60 and was " latitude " " RS $0 RS; } 
action == "validate" && NR > 1 && longitude && !is_numeric(longitude) { log_err("warning"); print "Field longitude in " FILENAME " line " NR " should be a numeric but was " longitude " " RS $0 RS; } 
action == "validate" && NR > 1 && longitude != "" && longitude < -110 { log_err("warning"); print "longitude in " FILENAME " line " NR " should be greater than -110 and was " longitude " " RS $0 RS; } 
action == "validate" && NR > 1 && longitude != "" && longitude > -120 { log_err("warning"); print "longitude in " FILENAME " line " NR " should be less than -120 and was " longitude " " RS $0 RS; } 
action == "validate" && NR > 1 && natural_subregion == "" { log_err("warning"); print "Field natural_subregion in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && natural_subregion != "" && natural_subregion !~ /^(CM|DM|NM|BSA|PAD|LBH|UBH|AP|ALP|SA|MT|UF|LF|KU|FP|PRP|CP|DMG|FF|NF|MG)$/ { log_err("warning"); print "natural_subregion in " FILENAME " line " NR " should match the following pattern /^(CM|DM|NM|BSA|PAD|LBH|UBH|AP|ALP|SA|MT|UF|LF|KU|FP|PRP|CP|DMG|FF|NF|MG)$/ and was " natural_subregion " " RS $0 RS; } 
action == "validate" && NR > 1 && ecosite_guide == "" { log_err("warning"); print "Field ecosite_guide in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && ecosite_guide != "" && ecosite_guide !~ /^(N|WC|SW)$/ { log_err("warning"); print "ecosite_guide in " FILENAME " line " NR " should match the following pattern /^(N|WC|SW)$/ and was " ecosite_guide " " RS $0 RS; } 
action == "validate" && NR > 1 && ecosite == "" { log_err("warning"); print "Field ecosite in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && ecosite != "" && ecosite !~ /^(a|b|c|d|e|f|g|h|I|j|k|l|m|n)$/ { log_err("warning"); print "ecosite in " FILENAME " line " NR " should match the following pattern /^(a|b|c|d|e|f|g|h|I|j|k|l|m|n)$/ and was " ecosite " " RS $0 RS; } 
action == "validate" && NR > 1 && ecosite_phase == "" { log_err("warning"); print "Field ecosite_phase in " FILENAME " line " NR " is required" RS $0 RS; } 
action == "validate" && NR > 1 && ecosite_phase != "" && ecosite_phase !~ /^(1|b1|b2|b3|b4|c1|d1|d2|d3|e1|e2|e3|f1|f2|f3|g1|h1|i1|i2|j1|j2|k1|k2|k3|l1|h2|j3|a2|a3|g2|h3|b5|c2|c3|c4|c5|d4|e4|f4|f5|f6|g3|i3|l2|l3|m1|m2|m3|n1)$/ { log_err("warning"); print "ecosite_phase in " FILENAME " line " NR " should match the following pattern /^(1|b1|b2|b3|b4|c1|d1|d2|d3|e1|e2|e3|f1|f2|f3|g1|h1|i1|i2|j1|j2|k1|k2|k3|l1|h2|j3|a2|a3|g2|h3|b5|c2|c3|c4|c5|d4|e4|f4|f5|f6|g3|i3|l2|l3|m1|m2|m3|n1)$/ and was " ecosite_phase " " RS $0 RS; } 

# sanitize rules
action ~ /^(sanitize|insert)$/ && NR > 1 {
    if (x_coord == "") $19 = "-9999"
    if (aspect == "") $18 = "NA"
    if (topographic_position == "") $15 = "NA"
    if (elevation == "") $16 = "-9999"
    if (ats_range == "") $10 = "NA"
    if (ats_section == "") $12 = "-9999"
    if (latitude == "") $23 = "-9999"
    if (sampling_unit_number == "") $14 = "NA"
    if (ecosite_guide == "") $26 = "NA"
    if (ats_township == "") $9 = "-9999"
    if (ecosite == "") $27 = "NA"
    if (opening_number == "") $13 = "NA"
    if (utm_zone == "") $21 = "NA"
    if (fmu == "") $7 = "NA"
    if (ats_meridian == "") $11 = "-9999"
    if (natural_subregion == "") $25 = "NA"
    if (y_coord == "") $20 = "-9999"
    if (company_plot_number == "") $2 = "NA"
    if (establishment_day == "") $6 = "-9999"
    if (longitude == "") $24 = "-9999"
    if (slope == "") $17 = "-9999"
    if (datum == "") $22 = "NA"
    if (establishment_year == "") $4 = "-9999"
    if (ecosite_phase == "") $28 = "NA"
    if (establishment_month == "") $5 = "-9999"
    if (company_stand_number == "") $3 = "NA"
    if (company == "") $1 = "NA"
    if (fma == "") $8 = "NA"
    if (plot_comment == "") $29 = "NA"
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
     print "CREATE TABLE IF NOT EXISTS  (datum text,company_plot_number text,latitude numeric,company_stand_number text,longitude numeric,establishment_year numeric,natural_subregion text,establishment_month numeric,ecosite_guide text,establishment_day numeric,ecosite text,fmu text,ecosite_phase text,fma text,plot_comment text,ats_township numeric,ats_range text,ats_meridian numeric,ats_section numeric,opening_number text,sampling_unit_number text,topographic_position text,elevation numeric,slope numeric,aspect text,x_coord numeric,y_coord numeric,utm_zone text,company text);"
}
action == "sanitize" { print }

# la fin
END {
    if (action == "insert") print "\\."
    if (action == "validate" && options["summary"] == "true") { print RS "violation summary: " RS "   counts:   " RS "      total: " err_count; print_cats(cats); }
}

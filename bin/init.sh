#!/usr/bin/env bash
set +o posix

# read in first line (header), replace comman with new line and print default rule for each field 
# usage: ./init.sh ./examples/afgo/*.csv

for csv in "$@"
do
    cat $csv | head -1 | tr , '\n' | awk -F, -v OFS=, '{ print "field","required",$1 }' > "${csv/.csv/.rules.csv}"
done

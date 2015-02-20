# bawlk

A simple tool to validate csv data. Uses awk under the hood but you don't need to know awk to use it. There are tools available to create a ruleset from existing data and another tool to create an awk validator from those ruleset.

awk is a very natural fit for validating csv data. Even though awk is a very complex language its quite simple in nature. With awk you get a free iterator, pattern matchin and rich expression language. awk is built-in most unix/linux systems and can be installed on windows based systems. gawk is a newer version of awk which extends the language further with more feature. Other variations like mawk take it a step further and optimizes awk for performance.

## Usage
bawlk are a set of tools to automate building an awk validation script. Once the script is built it is self contained and can be used independently. 

A typical workflow looks like this:

1. Create a ruleset from existing data. 
2. Edit the ruleset to add additional field or file constraints.
3. Generate your validator by passing in your ruleset to the bawlk.awk script.
4. Validate your data

#### 1. Create a ruleset from existing data.

````
$ ./bawlkinit.sh ./examples/pgyi/data/*.csv
field,required,CompanyPlotNumber
field,required,MeasurementNumber
field,required,TreeNumber
field,required,TreeType
field,required,DBH
field,required,DBHHeight
field,required,RCD
field,required,RCDHeight
field,required,Height
field,required,CrownClass
field,required,DBHage
field,required,Stumpage
field,required,StumpHeight
field,required,TotalAge
field,required,HTLC
field,required,CrownDiameterNS
field,required,CrownDiameterEW
field,required,ConditionCode1
field,required,Cause1
field,required,Severity1
field,required,ConditionCode2
field,required,Cause2
field,required,Severity2
field,required,ConditionCode3
field,required,Cause3
field,required,Severity3
field,required,TreesComment
```` 

#### 2. Edit the ruleset to add additional field or file constraints.

````
# fields are:
rule_type,rule_name,rule_params

# controls how error are handled (default=text)
# prints only errors inlcuding a desc and the resord itself
option,mode,text
# prints all records and wraps bad value in >>value<<
option,mode,wrap
# prints all records and appends the error to the record as a field
option,mode,append

# enable/disable printing a summary
option,summary,true

# set what the default violation catagory is. (default=na)
option,dcat,warning

# check to make sure headers match
headers,names,CompanyPlotNumber|MeasurementNumber|TreeNumber|TreeType|DBH|DBHHeight|RCD|RCDHeight|Height|CrownClass|DBHage|Stumpage|StumpHeight|TotalAge|HTLC|CrownDiameterNS|CrownDiameterEW|ConditionCode1|Cause1|Severity1|ConditionCode2|Cause2|Severity2|ConditionCode3|Cause3|Severity3|TreesComment

# check to make sure values are numeric
field,type,CompanyPlotNumber numeric

# check to make sure values are not null
field,required,CompanyPlotNumber

# check to make sure values are unique
field,unique,CompanyPlotNumber

# check to make sure values min/max
field,min,TreeNumber 1
field,max,TreeNumber 999999

# check to make sure values are within accepted values
field,values,TreeType T|S|PS|PO|R1|R2|R3|R4|B

# check to make sure values match a certain pattern
# not-implemented: field,pattern,TreeType /^(?:T|S|PS|PO|R1|R2|R3|R4|B)$/

# check composite/compound keys
# not-implemented: file,unique,CompanyPlotNumber MeasurementNumber

# set default values if value not  set
# not-implemented: field,default,Elevation -9999
# not-implemented: field,default,FMU NA
````

#### 3. Generate your validator by passing in your ruleset to the bawlk.awk script.

````
$ ./bawlk.awk < TreesMeasurement.rules.csv > TreesMeasurement.validator.awk
````

#### 4. Validate your data

````
$ TreesMeasurement.validator.awk < TreesMeasurement.csv > TreesMeasurement.violations.txt
````

## Advanced Usage

Your validator can either be used as is or be further customized if you feel comfortable with the awk language. 

## Roadmap
* add ability to pass in options from the ruleset i.e. error handling/messages/...
* add ability to validate csv dialect
* add ablity to pass in custom ``awk /patern/ { expression }``
* add ability to import/include third party libs
* add ability to validate floating point precision
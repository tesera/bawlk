# bawlk

>A simple CSV to RDBMS bulk validating/loading toolsets.
 bawlk.awk will generate an awk file which can be used to act on csv data in order to accomplish common tasks involved when bulk inserting data into a relational database or quality checking flat files. To use this tool, you do not need to know how to code in awk.  

awk is a very natural fit for validating and manipulating csv data. awk is a language designed for text processing, and is typically used for data extraction and processing. With awk you get a free iterator, pattern matching and rich expression language. awk is included in most unix/linux systems and can be installed on windows based systems. 

### Rule Sets

A rule set in this case is a set of constraints on a csv file. Contraints can include:
- Headers
- Field Types
- Ranges and Code Lists
- Ignored Values
- Unique Values 

## Tools Summary

1. ``./bin/init.sh`` : Creates a basic ruleset from an existing csv file.
2. ``./bin/bawlk.awk`` : Main tool which build an bulk loading awk script from a ruleset.
3. ``./bin/jts2rules.js`` : Converts a JSON Table Schema to a ruleset.
4. ``./bin/rules2jts.awk`` : Converts a ruleset to JSON Table Schema.

## Typical Workflow
Using the toolset you can build a bawlk awk script that can be used to validate and sanitize bulk insert data into a relational database. Once the script is built it is self contained and can be used independently. 

A typical workflow looks like this:

1. Create a ruleset from existing csv data. 
2. Edit the ruleset to add additional field or file constraints.
3. Generate your validator by passing in your ruleset to the bawlk.awk script.
4. Use the generated awk script to manage your csv data.

#### 1. Create a ruleset from existing csv data.

````
$ ./bin/init.sh ./examples/pgyi/data/Plot.csv
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

# rule_params for field rules (field_name rule_arg violation_category)
field,required,CompanyPlotNumber true error
field,min,TreeNumber 1 error
field,max,TreeNumber 999999 error

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

# check to make sure values match a certain pattern
field,pattern,TreeType /^(?:T|S|PS|PO|R1|R2|R3|R4|B)$/

````

#### 3. Generate your validator by passing in your ruleset to the bawlk.awk script.

````
$ ./bawlk.awk < TreesMeasurement.rules.csv > TreesMeasurement.validator.awk
````

#### 4. Use your bawlk awk script.

##### Validate (default action)
````
$ TreesMeasurement.awk -v action=validate TreesMeasurement.csv > violations.csv
````

##### Sanitize

````
$ TreesMeasurement.awk -v action=sanitize TreesMeasurement.csv > TreesMeasurement.cleaned.csv
````

##### Create table

````
$ TreesMeasurement.awk -v action=table TreesMeasurement.csv | psql afgo_dev
````

##### Bulk insert data

````
$ TreesMeasurement.awk -v action=insert TreesMeasurement.csv | psql afgo_dev
````

## Advanced Usage

Once your bawlk awk script is generated and you feel comfortable with awk you can edit it further if you have more comples rules by manual editing. The generated script is writen in a simple to understand syntax.

## Roadmap
* add ability to pass in options from the ruleset i.e. error handling/messages/...
* add ability to validate csv dialect
* add ablity to pass in custom ``awk /patern/ { expression }``
* add ability to import/include third party libs
* add ability to validate floating point precision
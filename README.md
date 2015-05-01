# bawlk

> bawlk as in bulk as in bulk loading

### A simple CSV to relational bulk validating/loading toolset.
The main tool bawlk.awk will generate an awk file which can be used to act on csv data in order to accomplish common task invloved when bulk inserting data into a relational database system. Although bawlk uses awk under the hood you don't need to know how to code in awk to use it. Bawlk also have some facilities to work with JSON Table Schemas.

### Why AWK?
awk is a very natural fit for validating and manipulating csv data. Even though awk is a very complex language its quite simple in nature. With awk you get a free iterator, pattern matching and rich expression language. awk is built-in most unix/linux systems and can be installed on windows based systems. gawk is a newer version of awk which extends the language further with more feature. Other variations like mawk take it a step further and optimizes awk for performance. Bawlk uses the basic awk language so no need to installl gawk.

### What is a JSON Table Schema?
A [JSON Table Schema](http://dataprotocols.org/json-table-schema/) (jts) is an open data meta definition of a resource represented in a JSON format. A schema defines the resource, its fields, field types, field constraints and many other meta related information required to be able to use the data. 

### Tools Summary

1. ``./bin/init.sh`` : Creates a basic ruleset from an existing csv file.
2. ``./bin/bawlk.awk`` : Main tool which build an bulk loading awk script from a ruleset.
3. ``./bin/bawlk.js`` : A bawlk.awk nodejswrapper w/ helpers.
3. ``./bin/jts2rules.js`` : Converts a JSON Table Schema to a ruleset.
4. ``./bin/rules2jts.awk`` : Converts a ruleset to JSON Table Schema.

## Typical Workflow
The end result is one awk script per resource which encasulates many actions you can take on your CSV resource. The awk script is portable and can be used to validate, sanitize, create host table and bulk insert data into a postgreSQL relational database. By portable we mean that the script is sefl contain and does not have any dependency other that awk itself.

There are two typical workflows you can use depending on your situation.

If you are starting out with an existing jts you will be using ``bawlk.js``:

1. create your ruleset: ``node ./bin/bawlk.js rules -d ./examples/pgyi/datapackage.json -o ./examples/pgyi/rules``
2. create your scripts: ``node ./bin/bawlk.js scripts -d ./examples/pgyi/datapackage.json -o ./examples/pgyi/awk``
3. use your scripts: ``awk -f ./examples/pgyi/plot.rules.csv ./examples/pgyi/data/plot.csv``

You can also jump straight to validate if you simply want to validate.
``node ./bin/bawlk.js validate -d ./examples/pgyi/datapackage.json > violations.csv``

If you are starting out with only csv files:

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

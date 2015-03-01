#!/usr/bin/env node
var fs = require('fs');
var argv = require('minimist')(process.argv.slice(2));
var JSONStream = require('JSONStream');
var es = require('event-stream');
var bawlk = require('../lib');
var Readable = require('stream').Readable;
var reduce = require("stream-reduce");
var spawn = require('child_process').spawn;


// usage:
//   bawlk rules -d datapackage.json -o ./rules
//   bawlk scripts -d datapackage.json -o ./awk
//   bawlk validate -d datapackage.json > violations.txt

var cmd = argv._[0];
var datapackage;

if (argv.d) {
    datapackage = fs.readFileSync(argv.d);
}

if (argv.o) {
    output = fs.createWriteStream(argv.o);
}

datapackage = JSON.parse(datapackage);

datapackage.resources.forEach(function (resource) {
    var outputFilePath;
    var outputFile;

    var resourceStream = new Readable({ objectMode: true });
    resourceStream.push(resource);
    resourceStream.push(null);

    switch(cmd) {
        case 'rules':
            outputFilePath = resource.path.replace('.csv', '.rules.csv');
            outputFile = fs.createWriteStream(outputFilePath);
            resourceStream
                .pipe(bawlk.getRuleset())
                .pipe(outputFile);
            break;
        case 'scripts':
            outputFilePath = resource.path.replace('.csv', '.awk');
            outputFile = fs.createWriteStream(outputFilePath);
            resourceStream
                .pipe(bawlk.getRuleset())
                .pipe(bawlk.getScript())
                .pipe(outputFile);
            break;
        case 'validate':
            var csv = fs.createReadStream('./examples/pgyi/data/' + resource.path);

            var bawlkStream = resourceStream
                .pipe(bawlk.getRuleset())
                .pipe(bawlk.getScript())
                .pipe(reduce(function (acc, chunk) {
                    return acc + chunk;
                }, ''))
                .pipe(es.through(function (script) {
                    var self = this;
                    var args = ['-v', 'FILENAME='+resource.path, script.toString('utf8')];
                    var awk = spawn('awk', args);

                    awk.stdout.setEncoding('utf8');

                    awk.stdout.on('data', function (data) {
                        self.emit('data', data);
                    });

                    awk.stdout.on('end', function (data) {
                        self.emit('end');
                    });

                    csv.pipe(awk.stdin);

                    self.pause();
                }))
                .pipe(process.stdout);
    }
});

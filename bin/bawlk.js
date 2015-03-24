#!/usr/bin/env node
var fs = require('fs');
var path = require('path');
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
} else throw new Error('datapackage required')


var outputPath = argv.o || '.'
datapackage = JSON.parse(datapackage);

var bawlkStreams;

datapackage.resources.forEach(function (resource) {
    var outputFilePath = path.resolve(outputPath, resource.path);

    var resourceStream = new Readable({ objectMode: true });
    resourceStream.push(resource);
    resourceStream.push(null);

    switch(cmd) {
        case 'rules':
            outputFilePath = outputFilePath.replace('.csv', '.rules.csv');
            resourceStream
                .pipe(bawlk.getRuleset())
                .pipe(fs.createWriteStream(outputFilePath));
            break;
        case 'scripts':
            outputFilePath = outputFilePath.replace('.csv', '.awk');
            resourceStream
                .pipe(bawlk.getRuleset())
                .pipe(bawlk.getScript())
                .pipe(fs.createWriteStream(outputFilePath));
            break;
        case 'validate':
            var csv = fs.createReadStream('./examples/pgyi/data/' + resource.path);

            bawlkStreams = resourceStream
                .pipe(bawlk.getRuleset())
                .pipe(bawlk.getScript())
                .pipe(reduce(function (acc, chunk) {
                    return acc + chunk;
                }, ''))
                .pipe(es.through(function (script) {
                    var self = this;
                    var args = [
                        '-v', 'action=validate:summary',
                        '-v', 'CSVFILENAME='+resource.path,
                        script.toString('utf8')
                    ];
                    var awk = spawn('awk', args);

                    awk.stdout.setEncoding('utf8');

                    awk.stdin.on('error', function (err) {
                        self.emit('end');
                    });

                    awk.stdout.on('data', function (data) {
                        self.emit('data', data);
                    });

                    awk.stdout.on('end', function (data) {
                        // console.log(resource.path);
                        self.emit('end');
                    });

                    csv.pipe(awk.stdin);

                    self.pause();
                })).pipe(process.stdout);
            break;
    }
});

// if (bawlkStreams) console.log('yo'); //es.merge(bawlkStreams).pipe(process.stdout);

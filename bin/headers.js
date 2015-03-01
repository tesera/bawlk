#!/usr/bin/env node
var es = require('event-stream');
var JSONStream = require('JSONStream');

process.stdin.resume();
process.stdin.setEncoding('utf8');

process.stdin
    .pipe(JSONStream.parse('resources.*'))
    .pipe(es.map(function (resource, callback) {
        var headers = resource.schema.fields.map(function(f) {return f.name});
        callback(null, ['', resource.path, headers.join(','), ''].join('\n'));
    }))
    .pipe(process.stdout);
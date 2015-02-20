#!/usr/bin/env node
var fs = require('fs');
var _ = require('lodash');
var csv = require('fast-csv');
var bawlk = require('../lib');
var stdin = process.stdin;

stdin.resume();
stdin.setEncoding('utf8');

stdin.on('data', function (chunk) {
    var datapackage = JSON.parse(chunk);
    datapackage.resources.forEach(function (resource) {
        var ruleset = bawlk.getRulesetsFromSchema(resource.schema);
        var filename = resource.path.replace('.', '.rules.');
        var fileStream = fs.createWriteStream(filename);
        ruleset.pipe(fileStream);
    });
});
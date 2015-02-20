#!/usr/bin/env node
var _ = require('lodash');
var csv = require('fast-csv');
var bawlk = require('../lib');
var stdin = process.stdin;

stdin.resume();
stdin.setEncoding('utf8');

stdin.on('data', function (chunk) {
    var json = JSON.parse(chunk);
    var schema = json.resources[0].schema;
    ruleset = bawlk.getRulesetsFromSchema(schema);
    ruleset.pipe(process.stdout);
});
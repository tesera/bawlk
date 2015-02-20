#!/usr/bin/env node
var _ = require('lodash');
var stdin = process.stdin;
var spawn = require('child_process').spawn;

stdin.resume();
stdin.setEncoding('utf8');

var csvalid = spawn('awk', ['-F', ',', '-f', './bawlk.awk']);

stdin.pipe(csvalid.stdin);
csvalid.stdout.pipe(process.stdout);
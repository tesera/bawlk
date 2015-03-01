'use strict';
var fs = require('fs');
var spawn = require('child_process').spawn;
var es = require('event-stream');
var path = require('path');

var bawlkPath = path.resolve(__dirname, '../bin/bawlk.awk');
var bawlk = fs.readFileSync(bawlkPath, {encoding: 'utf8'});

exports.getRuleset = function () {
    var stream = es.through(function (resource) {
        var headers = resource.schema.fields.map(function (f) {
            return f.name;
        });

        stream.emit('data', ['headers', 'names', headers.join('|')].join(',') + '\n');

        resource.schema.fields.forEach(function (f) {
            stream.emit('data', ['field', 'type', f.name + ' ' + f.type].join(',') + '\n');

            for (var c in f.constraints) 
                stream.emit('data', ['field', c, f.name + ' ' + f.constraints[c]].join(',') + '\n');

            if(!f.constraints) stream.emit('data', ['field', 'none', f.name].join(',') + '\n');
        });

    });

    return stream;
};

exports.getScript = function () {
    var awk = spawn('awk', ['-F', ',', bawlk.toString('utf8')]);
    return es.child(awk);
};

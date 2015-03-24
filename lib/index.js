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

        if(resource.name) stream.emit('data', ['file', 'table', resource.name].join(',') + '\n');

        if (resource.primaryKey) stream.emit('data', ['file', 'pkey', resource.primaryKey.join('|')].join(',') + '\n');

        if (resource.foreignKeys) {
            resource.foreignKeys.forEach(function (fk) {
                var key = [fk.reference.resource, fk.reference.fields.join('|')].join(' ');
                stream.emit('data', ['file', 'fkey', key].join(',') + '\n');
            });
        }

        stream.emit('data', ['headers', 'names', headers.join('|')].join(',') + '\n');

        resource.schema.fields.forEach(function (f) {
            var raises = f.raises ? ' ' + f.raises : '';

            stream.emit('data', ['field', 'type', f.name + ' ' + f.type + raises].join(',') + '\n');

            for (var key in f.constraints) {
                var value = f.constraints[key];
                if ('string' == typeof value) value = value.replace(/\s/g, '');
                stream.emit('data', ['field', key, f.name + ' ' + value + raises].join(',') + '\n');
            }

            if(!f.constraints) stream.emit('data', ['field', 'none', f.name].join(',') + '\n');
        });

    });

    return stream;
};

exports.getScript = function () {
    var awk = spawn('awk', ['-F', ',', bawlk.toString('utf8')]);
    return es.child(awk);
};

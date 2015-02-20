'use strict';
var _ = require('lodash');
var csv = require('fast-csv');

exports.getRulesetsFromSchema = function (schema) {
    var headers = [];
    var rules = _.chain(schema.fields).map(function (field) {
        var fr = [];
        headers.push(field.name);

        if (field.type !== 'string') {
            fr.push(['field', 'type', field.name + ' ' + field.type]);
        }

        _.forEach(field.constraints, function (arg, constraint) {
            arg = constraint != 'none' ? ' ' + arg : ''
            fr.push(['field', constraint, field.name + arg]);
        });

        if(!field.constraints) fr.push(['field', 'none', field.name])

        return fr;
    }).flatten().value();

    rules.unshift(['headers', 'names', headers.join('|')])

    return csv.write(rules);
};
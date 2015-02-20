'use strict';
var _ = require('lodash');
var csv = require('fast-csv');

exports.getRulesetsFromSchema = function (schema) {

    var rules = _.chain(schema.fields).map(function (field) {
        var fr = [];

        if (field.type !== "string") {
            fr.push(["field", "type", field.name + " " + field.type]);
        }

        _.forEach(field.constraints, function (arg, constraint) {
            fr.push(["field", constraint, field.name + " " + arg]);
        });

        return fr;
    }).flatten().value();

    return csv.write(rules);
};
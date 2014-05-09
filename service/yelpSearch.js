// Generated by CoffeeScript 1.7.1
(function() {
  var express, isMatch, levenshtein, max_discrepancy, port, svc, toLowerNoParens, yelp;

  express = require('express');

  levenshtein = require('./levenshtein.js');

  svc = express();

  yelp = require('yelp').createClient({
    consumer_key: 'fnAIzIA5cLF6NSl_Lr7Hbw',
    consumer_secret: '-lbNbJtdQJLIqW7AtV1xUfP5tBY',
    token: 'SkTYgQkbdmG6zgWIMqWpMHgiA-sudkEn',
    token_secret: '8actk2saU1JKQ2MfjDceow_Jzuw'
  });

  console.log("created clients");

  max_discrepancy = 10;

  toLowerNoParens = function(str) {
    return str.replace(/(\(.+?\))*/gim, '').trim().toLowerCase();
  };

  isMatch = function(l, r) {
    var prepared;
    prepared = function(str) {
      return toLowerNoParens(str).replace(/[-'*]*/gim, "").replace(/restraunt/g, "").trim();
    };
    return levenshtein.getEditDistance(prepared(l), prepared(r)) < max_discrepancy;
  };

  svc.get('/', function(req, resp) {
    var accumulateError, error, hasError, locationTerm, params, searchTerm, toError;
    resp.contentType('application/json');
    toError = function(e) {
      return {
        error: e
      };
    };
    searchTerm = req.query['s'];
    locationTerm = req.query['l'];
    hasError = false;
    error = toError("");
    accumulateError = function(e, str) {
      return e.error = e.error + str;
    };
    if (searchTerm != null) {
      searchTerm = toLowerNoParens(searchTerm);
    } else {
      hasError = true;
      accumulateError(error, 'No search term defined');
    }
    if (locationTerm != null) {
      locationTerm = toLowerNoParens(locationTerm);
    } else {
      hasError = true;
      accumulateError(error, 'No location Term defined');
    }
    if (hasError) {
      resp.send(error);
      return;
    }
    params = {
      location: locationTerm,
      sort: 0,
      term: searchTerm,
      limit: 10
    };
    return yelp.search(params, function(error, data) {
      var business, clip, matches, result;
      if (error) {
        resp.send(toError(error));
        return;
      }
      clip = function(biz) {
        return {
          name: biz.name,
          rating: biz.rating,
          reviewCount: biz.review_count,
          ratingImg: biz.rating_img_url_small,
          url: biz.url
        };
      };
      matches = (function() {
        var _i, _len, _ref, _results;
        _ref = data.businesses;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          business = _ref[_i];
          if (isMatch(business.name, searchTerm)) {
            _results.push(clip(business));
          }
        }
        return _results;
      })();
      if (matches.length === 0) {
        result = toError('No matching yelp business');
      } else {
        result = matches[0];
      }
      return resp.send(result);
    });
  });

  console.log("opening port");

  port = process.env.SVCPORT || 8080;

  svc.listen(port, function() {
    return console.log('started up!!!');
  });

}).call(this);

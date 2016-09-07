(function() {
  var _agent, _app, _assert, _super;

  _assert = require('assert');

  _super = require('supertest');

  _app = require('../sample/index');

  _agent = _super.agent(_app);

  describe("Test", function() {
    it("Get Static Router", function(done) {
      return _agent.get('/static/hello.html').expect(200).end(function(err, resp) {
        if (err) {
          console.log(err);
        }
        return done(err);
      });
    });
    it("Get api router has a filter", function(done) {
      return _agent.get('/api/A').expect(200).end(function(err, resp) {
        if (err) {
          console.log(err);
        }
        return done(err);
      });
    });
    return it("Get api router has b filter and all filter", function(done) {
      return _agent.get('/api/B').expect(200).end(function(err, resp) {
        if (err) {
          console.log(err);
        }
        return done(err);
      });
    });
  });

}).call(this);

_assert = require 'assert'
_super = require 'supertest'
_app = require '../sample/index'
_agent = _super.agent(_app)
describe("Test", ->

  it("Get Static Router", (done)->
    _agent.get('/static/hello.html')
      .expect(200)
      .end((err, resp)->
        console.log(err) if err
        done(err)
      )
  )
  it("Get api router has a filter", (done)->
    _agent.get('/api/A').expect(200)
    .end((err, resp)->
      console.log(err) if err
      done(err)
    )
  )

  it("Get api router has b filter and all filter", (done)->
    _agent.get('/api/B').expect(200)
    .end((err, resp)->
      console.log(err) if err
      done(err)
    )
  )
)
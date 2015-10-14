Base = require './base'
class B extends Base
  get: (req, resp, next)-> resp.send('B')

module.exports = new B()
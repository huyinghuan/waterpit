Base = require './base'
class A extends Base
  get: (req, resp, next)-> resp.send('A')

module.exports = new A()
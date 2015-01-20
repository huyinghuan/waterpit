Base = require './base'
class Employee extends Base
  get: (req, resp, next)->
    resp.send('hello')

module.exports = new Employee()
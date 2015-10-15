class BaseFilter
  constructor: ->
  all: (req, resp, next)-> next()

module.exports = BaseFilter
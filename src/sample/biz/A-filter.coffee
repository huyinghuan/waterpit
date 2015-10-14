
class AFilter
  constructor: ->

  get: (req, resp, next)->
    console.log 'A-filter'
    next()

module.exports = new AFilter()
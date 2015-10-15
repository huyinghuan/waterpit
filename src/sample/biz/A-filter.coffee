_BaseFilter = require('../../lib/index').BaseFilter

class AFilter extends _BaseFilter
  constructor: ->
  get: (req, resp, next)->
    console.log 'A-filter'
    next()

  all: (req, resp, next)->
    console.log "#{req.method} 被 A-filter忽略"
    next()

module.exports = new AFilter()
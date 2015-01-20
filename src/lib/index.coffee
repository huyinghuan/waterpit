Router = require './router'

class Waterpit
  constructor: (@router, routerMap)->
    @cwd = routerMap.cwd
    @map = routerMap.map
    @baseUrl = routerMap.baseUrl
    @initRouter()

  initRouter: ->
    for record in @map
      new Router(@router, record, @cwd, @baseUrl)


module.exports =
  Waterpit: Waterpit
  Base: require './base'
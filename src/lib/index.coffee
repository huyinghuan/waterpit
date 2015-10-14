Router = require './router'
Filter = require './filter'
class Waterpit
  constructor: (@router, routerMap)->
    @cwd = routerMap.cwd
    @map = routerMap.map or []
    @filter = routerMap.filter or []
    @baseUrl = routerMap.baseUrl
    @initFilter()
    @initRouter()

  initRouter: ->
    for record in @map
      new Router(@router, record, @cwd, @baseUrl)

  initFilter: ->
    for record in @filter
      new Filter(@router, record, @cwd, @baseUrl)

module.exports =
  Waterpit: Waterpit
  Base: require './base'
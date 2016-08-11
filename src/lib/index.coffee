Router = require './router'
Filter = require './filter'
Page = require './page'

class Waterpit
  constructor: (@router, routerMap)->
    @cwd = routerMap.cwd
    @maps = []
    if not routerMap.maps
      console.log "this map config is go out, please use maps replace."
      @maps = [{
        baseUrl: routerMap.baseUrl
        map: routerMap.map or []
      }]
    else
      @maps = [].concat(routerMap.maps)

    @filter = routerMap.filter or []
    @page = routerMap.page
    @initFilter()
    @initPage() if @page
    @initRouter()

  initRouter: ->
    for mapItem in @maps
      baseUrl = mapItem.baseUrl
      for record in mapItem.map
        new Router(@router, record, @cwd, baseUrl)

  initFilter: ->
    for record in @filter
      new Filter(@router, record, @cwd)

  initPage: ->
    new Page(@router, @page)


_Base = require './base'
_BaseFilter = require './base-filter'
module.exports =
  Waterpit: Waterpit
  Base: _Base
  BaseFilter: _BaseFilter
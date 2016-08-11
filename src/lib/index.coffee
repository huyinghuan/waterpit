Router = require './router'
Filter = require './filter'
Page = require './page'

class Waterpit
  constructor: (@router, routerMap)->
    @cwd = routerMap.cwd
    @maps = if routerMap.maps then [].concat(routerMap.maps) else []
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
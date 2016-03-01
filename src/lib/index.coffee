Router = require './router'
Filter = require './filter'
Page = require './page'

class Waterpit
  constructor: (@router, routerMap)->
    @cwd = routerMap.cwd
    @map = routerMap.map or []
    @filter = routerMap.filter or []
    @page = routerMap.page
    @baseUrl = routerMap.baseUrl
    @initFilter()
    @initPage() if @page
    @initRouter()

  initRouter: ->
    for record in @map
      new Router(@router, record, @cwd, @baseUrl)

  initFilter: ->
    for record in @filter
      new Filter(@router, record, @cwd, @baseUrl)

  initPage: ->
    new Page(@router, @page)


_Base = require './base'
_BaseFilter = require './base-filter'
module.exports =
  Waterpit: Waterpit
  Base: _Base
  BaseFilter: _BaseFilter
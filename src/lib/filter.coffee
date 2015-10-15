_ = require 'lodash'
_path = require 'path'
class Filter
  constructor: (router, record, cwd, baseUrl)->

    pathArray = [].concat(record.path)

    @ignoreArray = if record.ignore then [].concat(record.ignore) else []

    bizPathArr = [].concat(record.biz)
    bizPathArr = (_path.join(cwd, bizPath) for bizPath in bizPathArr)
    self = @
    #循环路径
    for apiPath in pathArray
      #业务循环
      for bizPath in bizPathArr
        self.matchRouter(bizPath, apiPath, router)

  matchRouter: (bizPath, apiPath, router)->
    self = @
    biz = require bizPath
    router.all(apiPath, (req, resp, next)->
      #匹配到忽略路径
      return next() if self.isMatchPath(req.path, self.ignoreArray)
      method = req.method.toLowerCase()
      #如果有对应的方法就用，如果没有就调用本身
      if biz[method] and _.isFunction(biz[method])
        biz[method](req, resp, next)
      else if biz['all'] and _.isFunction(biz['all'])
        biz.all(req, resp, next)
      else
        biz(req, resp, next)
    )

  isMatchPath: (path, arr)->
    for item in arr
      return true if _.isString(item) and path is item
      return true if _.isRegExp(item) and item.test(path)
    false


module.exports = Filter
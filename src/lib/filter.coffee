_ = require 'lodash'
_path = require 'path'
class Filter
  constructor: (router, record, cwd, baseUrl)->

    pathArray = [].concat(record.path)

    ignoreArray = [].concat(record.ignore)

    bizPath = _path.join(cwd, record.biz)

    self = @

    for item in pathArray
      biz =  require bizPath
      router.all(item, (req, resp, next)->
        #匹配到忽略路径
        return next() if self.isMatchPath(req.path, ignoreArray)
        method = req.method.toLowerCase()
        #如果有对应的方法就用，如果没有就调用本身
        if biz.hasOwnProperty(method)
          biz[method](req, resp, next)
        else
          biz(req, resp, next)
      )

  isMatchPath: (path, arr)->
    for item in arr
      return true if _.isString(item) and path is item
      return true if _.isRegExp(item) and item.test(path)
    false


module.exports = Filter
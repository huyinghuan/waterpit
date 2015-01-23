path = require 'path'
_ = require 'lodash'
class Router
  constructor: (router, record, cwd, baseUrl)->
    #访问的路径
    url = path.join baseUrl, record.path
    #biz文件所在
    bizPath = path.join cwd, record.biz
    #biz实例
    biz =  require bizPath
    methods = record.methods or {}
    self = @
    router.route(url)
      .all(self.getExecute(biz, methods['ALL'], 'all'))
      .get(self.getExecute(biz, methods['GET'], 'get'))
      .post(self.getExecute(biz, methods['POST'], 'post'))
      .put(self.getExecute(biz, methods['PUT'], 'put'))
      .delete(self.getExecute(biz, methods['DELETE'], 'delete'))

  getExecute: (biz, method, defMethod)->
    (req, resp, next)->
      if _.isString method
        biz[method](req, resp, next)
      else if method is false
        biz.noFound(req, resp, next)
      else
        biz[defMethod.toLowerCase()](req, resp, next)

module.exports = Router
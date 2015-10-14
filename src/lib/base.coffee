class Base
  constructor: ->
  all: (req, resp, next)-> next()
  get: (req, resp, next)-> @noFound(req, resp, next)
  post: (req, resp, next)-> @noFound(req, resp, next)
  put: (req, resp, next)-> @noFound(req, resp, next)
  delete: (req, resp, next)-> @noFound(req, resp, next)
  noFound: (req, resp, next)->
    resp.status(404).send("#{req.path} #{req.method} no found!")
  ###
    403无权限错误
  ###
  code403: (resp, message = "No access right")->
    resp.status(403).send(message)

  ###
    401认证错误
  ###
  code401: (resp, message = "Authentication fail")->
    resp.status(401).send(message)

  ###
    406 参数错误
  ###
  code406: (resp, message= "Params errors")->
    resp.status(406).send(message)

  ###
    500 服务器错误
  ###
  code500: (resp, message = "Server error")->
    resp.status(500).send(message)

  ###
    503 服务器暂停使用，正在维护
  ###
  code503: (resp, message = "Server is down for maintenance")->
    resp.status(503).send(message)

  ###
    205 重复内容
  ###
  code205: (resp, message = "repeat content")->
    resp.status(205).send(message)

module.exports = Base
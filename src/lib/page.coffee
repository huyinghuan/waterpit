_Handlebars = require 'handlebars'
_fs = require 'fs'
_path = require 'path'

class Page
  constructor: (route, @config)->
    @initHelper()
    @initRoute(route)

  initRoute: (route)->
    pathArray = [].concat(@config.path)
    self = @
    for path in pathArray
      route.get(path, (req, resp)->
        self.execute(req, resp)
      )

  initHelper: ->
    try
      helper = require(@config.helper)
      helper(_Handlebars)
    catch e
      "NO handlebar helper";

  execute: (req, resp)->
    params = req.params
    contextDir = @config.context
    templateDir = @config.template
    page = params.page
    def = page.split('.').shift()
    context = params.context or def
    template = params.template or def
    templatePath = _path.resolve(templateDir, "#{template}.hbs")
    #是否有模板文件
    try
      _fs.accessSync(templatePath, _fs.R_OK)
    catch e
      return resp.sendStatus(404)

    contextPath = _path.resolve(contextDir, context)
    try
      contextFn = require(contextPath)
    catch e
      return resp.sendStatus(404)

    _fs.readFile(templatePath, 'utf8', (err, content)->
      if err
        console.error err
        return resp.sendStatus(503)
      try
        compileTemplate = _Handlebars.compile(content)
        contextFn.call(req, (data)-> resp.send(compileTemplate(data)))
      catch e
        console.log e
        resp.sendStatus(503)
    )

module.exports = Page

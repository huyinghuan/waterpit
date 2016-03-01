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
    helper = require(@config.helper)
    helper(_Handlebars)

  execute: (req, resp)->
    params = req.params
    contextDir = @config.context
    templateDir = @config.template
    page = params.page
    def = page.split('.').shift()
    context = params.context or def
    template = params.template or def
    templatePath = _path.join(templateDir, "#{template}.hbs")
    contextPath = _path.join(contextDir, context)
    contextFn = require(contextPath)
    _fs.readFile(templatePath, 'utf8', (err, content)->
      if err
        console.error err
        return resp.sendStatus(500)

      compileTemplate = _Handlebars.compile(content)

      contextFn(params, req.query, (data)->
        resp.send(compileTemplate(data))
      )
    )






module.exports = Page

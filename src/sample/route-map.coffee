path = require 'path'

module.exports =
  cwd: path.join __dirname, 'biz'
  baseUrl: '/api'
  map: [
      {
        path: '/A'
        biz: 'A'
        method: delete: false
      }
      {
        path: '/A'
        biz: 'A'
        method: delete: false
      }
  ]
  filter: [
    {
      path: ['/api/*'] #
      ignore: [] #支持string和正则表达式
      biz: 'A-filter'
    }
  ]
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
        path: '/B'
        biz: 'B'
        method: delete: false
      }
  ]
  filter: [
# ------第一种方式
#    {
#      path: ['/api/*'] #
#      ignore: [/^\/api\/A$/] #支持string和正则表达式
#      biz: ['A-filter', 'B-filter']
#    }
# -------第二种方式
#    {
#      path: ['/api/*'] #
#      ignore: [/^\/api\/B$/] #支持string和正则表达式
#      biz: ['A-filter']
#    }
#    {
#      path: ['/api/*'] #
#      ignore: [/^\/api\/A$/] #支持string和正则表达式
#      biz: ['B-filter']
#    }
#---------第三种方式
    {
      path: ['/api/A', '/api/B']
      biz: ['A-filter', 'B-filter']
    }
  ]
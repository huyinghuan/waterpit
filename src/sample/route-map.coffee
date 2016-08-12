path = require 'path'

module.exports =
  cwd: path.join __dirname, 'biz'
  maps: [
    {
      baseUrl: '/api'
      map:[
        {
          path: '/A'
          biz: 'A'
          methods: delete: false
        }
        {
          path: '/B'
          biz: 'B'
          methods: delete: false
        }
      ]
    }
  ]
  filter: [
# ------第一种方式
    {
      path: ['/api/*'] #
      ignore: [/^\/api\/A$/] #支持string和正则表达式
      biz: ['All-filter']
    }
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
  page: {
    context: path.join __dirname, 'biz/render' #渲染器
    path: ['/static/:page'] #路径 /static/:context/:template/:page  默认情况使 page == template = context
    template: path.join __dirname, 'template' #模板位置
    helper: require('./biz/render/handlebar-helper')
    #errorHandle:
  }
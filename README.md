#water-pit
------
 水沟， 基于express 4.x的 Restful路由映射

## Install

```shell
npm install water-pit --save
```

## Getting Start
### 路由映射
路由映射关系：

```coffee
path = require 'path'
module.exports =
  cwd: path.join __dirname, 'biz'
  maps: [
    {
      baseUrl: '/api'
      map: [
        {
          path: '/A'
          biz: 'A'
          methods: DELETE: false
        },
        ...
      ]
    },
    ...
  ]
  filter: [
       {
         path: ['/api/*'] #
         ignore: [] #支持string和正则表达式
         biz: 'A-filter'
       }
   ]
```

##### cwd
  表示业务逻辑的根目录， 请求的最终业务逻辑是  path.resolve(cwd, bizMap.biz)
  bizMap为map中的元素， 如上述配置请求的是 path.join(__dirname, 'biz', biz)这个业务逻辑

##### baseUrl
  基础访问路径， 映射到客户端的 最终路径是 path.join(baseUrl, bizMap.path)
  如上述配置 客户端端需访问/api/A 才能映射到biz逻辑

##### map
  路由映射关系， 数组。
  path 访问路径（注意实际路径！！！会！！！加入baseUrl构成）
  biz 业务逻辑名字（文件名）
  method restful类型映射
  完整的如下：

```coffee
methods:{
  GET: true, PUT: true, POST: true, Delete: true, ALL: true
}
```

上述值为默认值， 如需要禁止掉某种 类型 设置为false即可。 每种访问类型，对应的是业务逻辑biz相关的方法。
如GET默认调用业务逻辑的get， POST默认调用biz的post 等。
 
当然你也可以指定某个访问类型调用指定的方法如：

GET调用业务逻辑的```getAll```, PUT调用```update```， 其他使用默认函数映射

```coffeee
methods:{
  GET: 'getAll', PUT: 'update'
}
```

### Filter
  过滤器．放在所有请求前面．数组
  
  path 数组． 访问路径
  
  ignore 
    数组．在匹配的路径里面忽略哪些路径． 可选
    支持string和正则表达式，为string时，常用 ```=== request.path```来判断是否护绿．
  
  biz 数组或单个元素 业务逻辑名字（文件名）
  
  biz业务逻辑必须满足如下结构
    

```coffee
module.exports = (request, response, next)->
  ....
  next()  
  
or
BaseFilter = require('water-pit').BaseFilter

# 未在Filter中进行定义，那么就会调用该类的all函数．因此all是必须的．你可以自己实现或者继承BaseFilter

###
#这样的写法的话这里必须继承BaseFilter. 如果不继承，则需要实现all方法.
#Filter这样的写法，Water-pit会帮你实现，当拦截的是GET请求时，访问get方法，POST去请求时，访问POST.
#如果该请求类型未在Filter中进行定义，那么就会调用该类的all函数．因此all是必须的．你可以自己实现或者继承BaseFilter
###
class DemoFilter extend BaseFilter
  constructor: ->
  get: (req, resp, next)->
    ....
    next()
  ...
  #如果没有继承BaseFilter,那么这个函数是必须的
  all: (request, response, next)-> next()
```
不管上述哪种写法，除非你确定请求不需要走到下个拦截器或者业务逻辑，
那么一定不要提前写出response流并且在函数执行末尾调用next()方法，
让request请求进入到下一个阶段

### 业务逻辑
业务逻辑需要遵循一定的规范.如下：

```javascript
module.exports = {
  all: function(request, respone, next){ ... }
  get: function(request, respone, next){ ... }
  post: function(request, respone, next){ ... }
  put: function(request, respone, next){ ... }
  delete: function(request, respone, next){ ... }
}
```

也就是必须包含上述方法。上述的request, respone, next都与express中router函数中的相同
（提示：你可以通过继承来避免每个类都必须产生上述函数）

如果你使用coffee那么实现非常简单：

```coffee
Base = require('water-pit').Base
class Employee extends Base
  constructor:->
moudle.exports = new Employee
```

Base默认帮你实现了CURDA方法，当然，以上默认实现的方法都是以404为返回结果


#### Page 渲染静态模板
  
```coffee
 page: {
    context: path.join __dirname, 'render' #上下文数据所在文件夹
    path: ['/static/:page'] #路径 /static/:context/:template/:page  默认情况使 page == template = context
    template: path.join __dirname, 'template' #模板位置
    helper: require('xxxxx') #模板helper 可选配置
    errorHandle: require('xxx') #错误处理 可选配置
  }
```

@params ```context```

  渲染器上下文的根目录. 函数必须符合如下标准:
  
```coffee
module.export = (cb)->
  ...
  #cb  上下文回调
  #data 提供编译模板所需要的数据
  必须执行 cb(error, data)

  #注: req 以上下文的方式提供, 该函数内 this == req
```

  将模板的上下文传入回调函数.

@params ```path```

需要渲染模板的request请求路径

```
req.params中 
 context 用来指定上下文获取函数, 可选, 当不存在时 , context = page
 template 用来指定渲染哪个模板文件(不用带后缀)
 page是必须的 用来描述渲染url, 同时当context, template缺失时,用来给context, template赋值
 
```

@params  ```template```

用来指定模板文件所在的文件夹

@params ```helper```

用来指定自定义模板助手. 模板助手必须满足以下标准

```coffee
module.exports = (Handlebars, config)->
  Handlebars.registerHelper("A", (xx)-> xxx)
  Handlebars.registerHelper("B", (xx)-> xxx)
  ...
```

@params ```errorHandle```

当```context```上下文获取函数出错时, 调用了 ```cb(error)``` 那么该errorHandle会执行,
他必须满足一下标注:

```coffee
# error 为context传过来的错误消息.
module.exports = (error, request, response)->
    ...
    response.send somethings
```

改参数为可选参数,如果没有设置,那么发生错误 默认发送503 http status code.



### Demo

```coffee
express = require 'express'
Waterpit = require('waterpit').Waterpit

RouterMap =
  cwd: path.join __dirname, 'biz'
  maps:
    [{
      baseUrl: '/api'
      map: [
          {
            path: '/employee'
            biz: 'employee'
            methods: delete: false
          }
      ]
    }]

app = express()
router = express.Router()
water = new Waterpit(router, RouterMap)
app.use('/', router)
app.listen(3000)
```

具体示例请查看src/sample文件夹

### Test

```shell
npm test
```

Test Result:

```
/src/converage/Icov-report/index.html
```

### LICENSE

MIT

### Suggestion and issue
欢迎 在issue处提出任何新功能 或者bug 请求

### Histroy
1.1.0
  
  该版本不兼容以前的config设置包括render设置
  1. 增加模板渲染时的错误handle.

1.0.1 
该版本为兼容版本

修改routeMap 规则为数组,可以设置多个前缀开始的biz

0.0.8

 增加静态模板渲染数据函数的上下文为session

0.0.5
 
 增加静态模板渲染, 修改sample

0.0.4

  增加filter配置．修改sample

0.0.1 基本功能完善

0.0.2 bug修复
  修复route-map的属性读取错误

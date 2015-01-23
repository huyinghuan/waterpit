#water-pit
------
 水沟， 基于express 4.x的 Restful路由映射

## Install

```
npm install water-pit --save
```

## Getting Start
### 路由映射
路由映射关系：

```
path = require 'path'
module.exports =
  cwd: path.join __dirname, 'biz'
  baseUrl: '/api'
  map: [
      {
        path: '/employee'
        biz: 'employee'
        methods: DELETE: false
      },
      ....
  ]
```

cwd
  表示业务逻辑的根目录， 请求的最终业务逻辑是  path.join(cwd, bizMap.biz)
  bizMap为map中的元素， 如上述配置请求的是 path.join(__dirname, 'biz', biz)这个业务逻辑

baseUrl
  基础访问路径， 映射到客户端的 最终路径是 path.join(baseUrl, bizMap.path)
  如上述配置 客户端端需访问/api/employee才能映射到biz逻辑

map
  映射关系， 数组。
  path 访问路径（注意实际路径会加入baseUrl构成）
  biz 业务逻辑名字（文件名）
  method restful类型映射
  完整的如下：

```
methods:{
  GET: true, PUT: true, POST: true, Delete: true, ALL: true
}
```
上述值为默认值， 如需要禁止掉某种 类型 设置为false即可。 每种访问类型，对应的是业务逻辑biz相关的方法。
如GET默认调用业务逻辑的get， POST默认调用biz的post 等。 当然你也可以指定某个访问类型调用指定的方法如：

```
method:{
  GET: 'getAll', PUT: 'update'
}
```

GET调用业务逻辑的```getAll```, PUT调用```update```， 其他使用默认函数映射

### 业务逻辑
业务逻辑需要遵循一定的规范.如下：

```
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

```
Base = require('water-pit').Base
class Employee extends Base
  constructor:->
moudle.exports = new Employee
```

Base默认帮你实现了CURDA方法，当然，以上默认实现的方法都是以404为返回结果

### Demo

```
express = require 'express'
Waterpit = require('waterpit').Waterpit

RouterMap =
  cwd: path.join __dirname, 'biz'
  baseUrl: '/api'
  map: [
      {
        path: '/employee'
        biz: 'employee'
        methods: delete: false
      }
  ]

app = express()
router = express.Router()
water = new Waterpit(router, RouterMap)
app.use('/', router)
app.listen(3000)
```

具体示例请查看src/sample文件夹

### LICENSE

MIT

### Suggestion and issue
欢迎 在issue处提出任何新功能 或者bug 请求

### Histroy

0.0.1 基本功能完善

0.0.2 bug修复
  修复route-map的属性读取错误

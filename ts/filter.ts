import * as _ from 'lodash'
import * as _path from 'path'
function getBizPathArr(cwd:string, bizPathArr:Array<string>):Array<string>{
  let queue:Array<string> = []
  for(let bizPath of bizPathArr){
    queue.push(_path.join(cwd, bizPath))
  }
  return queue;
}
function isMatchPath(path, arr):boolean{
    for(let item of arr){
      if(_.isString(item) && path === item){
        return true
      }
      if(_.isRegExp(item) && item.test(path)){
        return true
      }
    }
    return false
}
class Filter{
  ignoreArray: Array<any>;
  constructor(router, record, cwd){
    let pathArray:Array<string> = [].concat(record.path);
    this.ignoreArray =  record.ignore ? [].concat(record.ignore) : [];
    let bizPathArr:Array<string> = [].concat(record.biz)
    bizPathArr =  getBizPathArr(cwd, bizPathArr)
    let self = this;
    //循环路径
    for(let apiPath of pathArray){
      //业务循环
      for(let bizPath of bizPathArr){
        self.matchRouter(bizPath, apiPath, router)
      }
    }   
  }
  matchRouter(bizPath:string, apiPath, router){
    let self = this;
    let biz = require(bizPath)
    router.all(apiPath, (req, resp, next)=>{
      //匹配到忽略路径
      if(isMatchPath(req.path, self.ignoreArray)){
        return next() 
      }
      let method = req.method.toLowerCase()
      //如果有对应的方法就用，如果没有就调用本身
      if(biz[method] && _.isFunction(biz[method])){
        biz[method](req, resp, next)
      }else if(biz['all'] && _.isFunction(biz['all'])){
        biz.all(req, resp, next)
      }else{
        biz(req, resp, next)
      }
    })
  }
}
export = Filter
import * as _path from 'path';
import * as _ from 'lodash';
export default class Router{
  constructor(router, record, cwd, baseUrl){
    //访问的路径
    let url:string = _path.join(baseUrl, record.path)
    //biz文件所在
    let bizPath:string = _path.join(cwd, record.biz)
    //biz实例
    let biz =  require(bizPath)
    let methods = record.methods || {}
    let self = this
    router.route(url)
      .all(self.getExecute(biz, methods['ALL'], 'all'))
      .get(self.getExecute(biz, methods['GET'], 'get'))
      .post(self.getExecute(biz, methods['POST'], 'post'))
      .put(self.getExecute(biz, methods['PUT'], 'put'))
      .delete(self.getExecute(biz, methods['DELETE'], 'delete'))
  }
  getExecute(biz, method, defMethod){
    return (req, resp, next)=>{
      if(_.isString(method)){
        biz[method](req, resp, next)
      }
      else if(method == false){
        biz.noFound(req, resp, next)
      }
      else{
        biz[defMethod.toLowerCase()](req, resp, next)
      }
    }
  }   
}
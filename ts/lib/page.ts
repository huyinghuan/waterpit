import * as _Handlebars from 'handlebars'
import * as _fs from 'fs' 
import * as _path from 'path'

class Page{
  private config:any
  constructor(route, config){
    this.config = config
    this.initHelper()
    this.initRoute(route)
  }
    

  initRoute(route){
    let pathArray:Array<string> = [].concat(this.config.path)
    let self = this
    for(let path of pathArray){
      route.get(path, (req, resp)=>{
        self.execute(req, resp)
      })
    }

  }
  initHelper(){
    if(this.config.helper){
      this.config.helper(_Handlebars)
    }else{
      console.log("NO handlebar helper");
    }
  }

  execute(req, resp){
    let params = req.params;
    let contextDir:string = this.config.context;
    let templateDir:string = this.config.template;
    let page = params.page;
    let def:string = page.split('.').shift()
    let context = params.context || def
    let template = params.template || def
    let templatePath = _path.resolve(templateDir, `${template}.hbs`)
    let errorHandle = this.config.errorHandle || function(error, req, resp){resp.sendStatus(503)}
    //是否有模板文件
    try{
      _fs.accessSync(templatePath, _fs.R_OK)
    }catch(e){
      return resp.sendStatus(404)
    }

    let contextPath = _path.resolve(contextDir, context)
    try{
      var  contextFn = require(contextPath)
    }catch(e){
      return resp.sendStatus(404)
    }
      
    _fs.readFile(templatePath, 'utf8', (err, content)=>{
      if(err){
        console.error(err)
        return resp.sendStatus(503)
      }
        
      try{
        let compileTemplate = _Handlebars.compile(content)
        contextFn.call(req, (error, data)=>{
          if(!error){
            return resp.send(compileTemplate(data))
          }
          errorHandle(error, req,  resp)
        })
      }catch(e){
        console.log(e)
        resp.sendStatus(503)
      } 
    })
  }
}

export default Page

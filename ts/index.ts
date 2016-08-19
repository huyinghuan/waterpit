import * as Router from './router'
import * as Filter from './filter'
import * as Page from './page'
import * as _Base from './base'
import * as _BaseFilter from './base-filter'

class Waterpit{
  router: any;
  cwd: string;
  maps: Array<any>;
  filter: any;
  page: any;
  constructor(router, routerMap){
    this.router = router;
    this.cwd = routerMap.cwd;
    this.maps =  routerMap.maps ? [].concat(routerMap.maps) : [];
    this.filter = routerMap.filter || [];
    this.page = routerMap.page;
    this.initFilter()
    this.page && this.initPage()
    this.initRouter()
  }

  initRouter(){
    let maps = this.maps;
    let self = this;
    for(let i = 0, length = maps.length; i < length; i++){
      let mapItem = maps[i];
      let baseUrl = mapItem.baseUrl;
      for(let j = 0, len = mapItem.map.length; j < len; j++){
        let record = mapItem.map[j];
        new Router(self.router, record, self.cwd, baseUrl)
      }
    }
  }
    

  initFilter(){
    let filter = this.filter;
    for(let i = 1, length = filter.length; i < length; i++){
      let record = filter[i];
      new Filter(this.router, record, this.cwd)
    } 
  }
    

  initPage(){
    new Page(this.router, this.page)
  }
}

export {
  Waterpit,
  _Base as Base,
  _BaseFilter as BaseFilter
}
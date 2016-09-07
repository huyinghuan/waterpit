class Base{
    constructor(){}
    all(req, resp, next){next()}
    get(req, resp, next){this.noFound(req, resp, next)}
    post(req, resp, next){this.noFound(req, resp, next)} 
    put(req, resp, next){this.noFound(req, resp, next)} 
    delete(req, resp, next){this.noFound(req, resp, next)} 
    noFound(req, resp, next){resp.status(404).send(`${req.path} ${req.method} no found!`)}
}
export default Base
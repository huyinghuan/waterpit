class BaseFilter{
    constructor(){}
    all(req, resp, next){next()}
}

export = BaseFilter
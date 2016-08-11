express = require 'express'
Waterpit = require('../lib/index').Waterpit
RouterMap = require './route-map'
app = express()
router = express.Router()
water = new Waterpit(router, RouterMap)
app.use('/', router)
app.listen(3400)
module.exports = app
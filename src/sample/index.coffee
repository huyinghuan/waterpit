express = require 'express'
bodyParser = require 'body-parser'
multer = require 'multer'

app = express()

router = express.Router()

router.use bodyParser.json()
router.use bodyParser.urlencoded extended: true
router.use multer()
router.use express.static(__dirname + '/static')

#类似拦截器
router.use((req, res, next)->
  console.log('%s %s %s', req.method, req.url, req.path)
  next()
)


router.use '/index/:id', (req, res, next)->
  console.log req.query
  #console.log req.headers
  console.log req.body
  console.log req.params
  res.send "hello router"

app.use '/', router

app.listen 3000
path = require 'path'

module.exports =
  cwd: path.join __dirname, 'biz'
  baseUrl: '/api'
  map: [
      {
        path: '/employee'
        biz: 'employee'
        method: delete: false
      }
  ]
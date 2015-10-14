module.exports = (req, resp, next)->
  console.log 'B-filter'
  next()
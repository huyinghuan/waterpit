module.exports = (cb)->
  cb(null, {time: new Date().getTime(), id: @query.id})
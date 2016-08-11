module.exports = (cb)->
  cb({time: new Date().getTime(), id: @query.id})
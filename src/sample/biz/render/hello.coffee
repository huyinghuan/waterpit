module.exports = (params, query, cb)->
  cb({time: new Date().getTime(), id: query.id})
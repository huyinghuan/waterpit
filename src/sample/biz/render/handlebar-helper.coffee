module.exports = (Handlebars, config)->
  Handlebars.registerHelper("format", (time)->
    d = new Date(time)
    "#{d.getFullYear()}-#{d.getMonth()}-#{d.getDate()}"
  )

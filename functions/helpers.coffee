_ = require 'lodash'
moment = require 'moment'

module.exports = {

  ###*
   * Function Preset ajax request.
   * @param {String} URL
   * @callback {Function} Callback
  ###
  ajaxRequest: (url, cb) ->
    $.ajax({url: url, timeout: 10000})
      .fail (err) ->
        console.log err
        cb err
      .done (body) ->
        cb null, body


  ###*
   * Function Adds % to string.
   * @param {String} Text.
   * @returns {String} Formated String.
  ###
  wins: (text) ->
    return text.toString() + '%'


  ###*
   * Function Compares version numbers. Returns 1 if left is highest, -1 if right, 0 if the same.
   * @param {String} First (Left) version number.
   * @param {String} Second (Right) version number.
   * @returns {Number}.
  ###
  versionCompare: (left, right) ->
    if typeof left + typeof right != 'stringstring'
      return false

    a = left.split('.')
    b = right.split('.')
    i = 0
    len = Math.max(a.length, b.length)

    while i < len
      if a[i] and !b[i] and parseInt(a[i]) > 0 or parseInt(a[i]) > parseInt(b[i])
        return 1
      else if b[i] and !a[i] and parseInt(b[i]) > 0 or parseInt(a[i]) < parseInt(b[i])
        return -1
      i++

    return 0


  ###*
   * Function That parses Champion.GG HTML. Kept out of Championify.coffee as it'll rarely ever change.
   * @param {Function} Cheerio.
   * @returns {Object} Object containing Champion data.
  ###
  compileGGData: ($c) ->
    data = $c('script:contains("matchupData.")').text()
    data = data.replace(/;/g, '')

    processed = {}

    query = _.template('matchupData.<%= q %> = ')
    _.each data.split('\n'), (line) ->
      _.each ['championData', 'champion'], (field) ->
        search = query({q: field})

        if _.includes(line, search)
          line = line.replace(search, '')
          processed[field] = JSON.parse(line)

    return processed


  ###*
   * Function Pretty console log, as well as updates the progress div on interface
   * @param {String} Console Message.
  ###
  cl: (text) ->
    m = moment().format('HH:mm:ss')
    m = ('['+m+'] | ') + text
    console.log(m) if window.devEnabled
    $('#cl-progress').prepend('<span>'+text+'</span><br />')


  ###*
   * Function Updates the progress bar on the interface.
   * @param {Number} Increment progress bar.
  ###
  updateProgressBar: (incr) ->
    this.incr = 0 if !this.incr
    this.incr += incr
    $('.progress-bar').attr('style', 'width: '+Math.floor(this.incr)+'%')
    if this.incr >= 100
      window.Championify.remote.getCurrentWindow().setProgressBar(-1)
    else
      window.Championify.remote.getCurrentWindow().setProgressBar(this.incr / 100)

}

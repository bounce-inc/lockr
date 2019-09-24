import i18n from './i18n'

export human_readable_size = (size) ->
  if size >= 1 << 30
    size /= 1 << 30
    unit = 'G'
  else if size >= 1 << 20
    size /= 1 << 20
    unit = 'M'
  else if size >= 1 << 10
    size /= 1 << 10
    unit = 'K'
  else
    unit = ' '

  if size < 10
    size = Math.round(size * 100) / 100
  else if size < 100
    size = Math.round(size * 10) / 10
  else
    size = Math.round(size)

  "#{size}#{unit}#{i18n.t('util_bytes')}"

export locale_date_time = (d) ->
  zerofill = (x) -> ('0' + x).slice -2
  if i18n.lang == 'ja'
    Y = d.getFullYear()
    M = d.getMonth() + 1
    D = d.getDate()
    h = zerofill d.getHours()
    m = zerofill d.getMinutes()
    s = zerofill d.getSeconds()
    "#{Y}/#{M}/#{D} #{h}:#{m}:#{s}"
  else
    d.toLocaleString()

export human_readable_time = (t) ->
  MINUTE = 60
  HOUR = 60 * MINUTE
  DAY = 24 * HOUR

  round = (x, unit) -> Math.round(x / unit) * unit
  if t > 10 * DAY then t = round t, DAY
  else if t > DAY then t = round t, HOUR
  else if t > HOUR then t = round t, 10 * MINUTE
  else if t > 10 * MINUTE then t = round t, MINUTE
  else t = round t, 10

  result = []
  if t >= DAY
    result.push i18n.t 'app_days', days: Math.floor t / DAY
    t %= DAY
  if t >= HOUR
    result.push i18n.t 'app_hours', hours: Math.floor t / HOUR
    t %= HOUR
  if t >= MINUTE
    result.push i18n.t 'app_minutes', minutes: Math.floor t / MINUTE
    t %= MINUTE
  if t
    result.push i18n.t 'app_seconds', seconds: Math.floor t
  else if result.length == 0
    result.push i18n.t 'app_few_seconds'

  if i18n.lang == 'ja'
    result.join ''
  else
    result.join ' '

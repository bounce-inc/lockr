KEY = 'lockr_metadata'
MAX = 50

export default do ->
  json = localStorage[KEY]
  metadata =
    if json
      metadata = JSON.parse json
    else
      {}

  get: (id) -> metadata[id][0]

  set: (id, data) ->
    while Object.keys(metadata).length >= MAX
      @spill()
    metadata[id] = [data, Date.now()]
    localStorage[KEY] = JSON.stringify metadata

  spill: ->
    oldest = Infinity
    oldest_id = null
    for id, data of metadata
      time = data[1]
      if time < oldest
        oldest = time
        oldest_id = id
    if oldest_id
      delete metadata[oldest_id]

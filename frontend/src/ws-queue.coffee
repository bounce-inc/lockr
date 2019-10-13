import Queue from './queue'

export default class QueuedWebSocket
  open: (url) ->
    @ws = new WebSocket url
    @ws.binaryType = 'arraybuffer'
    @queue = new Queue Infinity
    @closed = false
    @error = false

    new Promise (resolve, reject) =>
      @ws.onmessage = (ev) => @queue.write ev.data

      @ws.onclose = (ev) =>
        e = new Error 'wsclose'
        @queue.error e
        reject e

      @ws.onerror = (ev) =>
        e = new Error 'websocket'
        @queue.error e
        reject e

      @ws.onopen = (ev) -> resolve()

  read: -> @queue.read()

  write: (msg) ->
    if @queue.err
      throw @queue.err
    @ws.send msg

  close: ->
    while @ws.bufferedAmount > 0
      await new Promise (resolve) -> setTimeout resolve, 30
    @ws.close()

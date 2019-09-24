export default class WebSockPromised
  constructor: (url, @buffer_max=256*1024) ->
    @ws = new WebSocket url
    @ws.binaryType = 'arraybuffer'
    @queue = []
    @closed = false
    @error = false
    @waiter = null
    @ws.onmessage = (ev) => @onmessage ev
    @ws.onclose = (ev) => @onclose ev
    @ws.onerror = (ev) => @onerror ev
    @open_p = new Promise (resolve) =>
      @ws.onopen = => resolve()

  open: ->
    @check()
    await @open_p
    @check()

  onmessage: (ev) ->
    @queue.push ev.data
    if @waiter
      @waiter()
      @waiter = null

  onclose: (ev) ->
    @closed = true
    if @waiter
      @waiter()
      @waiter = null

  onerror: (ev) ->
    @error = true
    if @waiter
      @waiter()
      @waiter = null

  receive: ->
    unless @queue.length
      @check()
      await new Promise (resolve) => @waiter = resolve
      @check()
    @queue.shift()

  nonblocking_receive: ->
    unless @queue.length
      @check()
      return null
    @queue.shift()

  send: (msg) ->
    @check()
    @ws.send msg

  close: ->
    while @ws.bufferedAmount > 0
      await @sleep()
    @ws.close()

  check: ->
    if @error
      throw new Error 'websocket'
    if @closed
      throw new Error 'connection'

  sleep: -> new Promise (resolve) -> setTimeout resolve, 20

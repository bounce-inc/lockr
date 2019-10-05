import Crypto from './crypto'
import Decrypter from './decrypter'
import Queue from './queue'

downloads = {}
last_id = 0

class StreamDecrypter extends Decrypter
  constructor: (params) ->
    super()
    Object.assign @, params

  push: (data) -> await @queue.write data

  onprogress: (status, progress) ->
    @port.postMessage type: 'progress', param: { status, progress }

  finish: ->
    @queue.write new Uint8Array 0
    @port.postMessage type: 'end'

  error: (e) ->
    @queue.error e
    unless e.message == 'CANCEL'
      @port.postMessage type: 'error', param:
        message: e.message
        detail: e.detail
        status: e.status

class Download
  constructor: (params, port) ->
    Object.assign @, params
    @port = port
    @crypto = new Crypto
    @queue = new Queue

  respond: ->
    timer = null

    stream = new ReadableStream
      start: =>
        @download()
        return # not to return promise

      pull: (ctrl) =>
        try
          data = await @queue.read()
        catch e
          ctrl.error()
          return

        if data.length == 0
          clearTimeout timer if timer
          ctrl.close()
        else
          ctrl.enqueue data

          # Chrome doesn't call cancel so use timeout
          clearTimeout timer if timer
          timer = setTimeout (=>
            console.log 'here'
            @cancel()
            ctrl.error()
          ), 15 * 1000

      cancel: => @cancel()

    new Response stream, headers:
      'Content-Type': @meta.type or 'application/octet-stream'
      'Content-Length': @meta.size
      'Content-Disposition': 'attachment'
      'X-Download-Options': 'noopen'
      'X-Content-Type-Options': 'nosniff'
      # Last-Modified

  download: ->
    await @crypto.init @secret
    @crypto.set_salt @salt
    @decrypter = new StreamDecrypter
      id: @id
      crypto: @crypto
      token: @token
      meta: @meta
      signature: @signature
      port: @port
      queue: @queue
    @decrypter.decrypt()

  cancel: ->
    @decrypter?.cancel()

  resume: ->
    @decrypter?.resume()

self.addEventListener 'install', (ev) ->
  console.log 'sw installed'
  self.skipWaiting()

self.addEventListener 'activate', (ev) ->
  console.log 'sw activated'
  self.clients.claim()

self.addEventListener 'fetch', (ev) ->
  try
    url = new URL ev.request.url
    path = url.pathname
    if path.startsWith '/service-worker-internal/decrypter/'
      id = path.split('/')[3]
      download = downloads[id]
      if download
        ev.respondWith download.respond()
      else
        ev.respondWith new Response null, status: 404
  catch e
    console.error e

self.addEventListener 'message', (ev) ->
  { command, id, param } = ev.data
  port = ev.ports[0]
  try
    switch command
      when 'start'
        id = ++last_id
        downloads[id] = new Download param, port
        port.postMessage id
      when 'ping'
        port.postMessage 'pong'
      when 'cancel'
        download = downloads[id]
        if download
          download.cancel()
          delete downloads[id]
          port.postMessage 'ok'
        else
          port.postMessage 'not found'
  catch e
    console.error e
    port.postMessage error: e.message

import Crypto from './crypto'
import Decrypter from './decrypter'

downloads = {}
last_id = 0

class StreamDecrypter extends Decrypter
  constructor: (params) ->
    super()
    Object.assign @, params

  push: (data) ->
    if @ctrl.desiredSize <= 0
      await new Promise (resolve, reject) =>
        timeout = setTimeout (=>
          @cancel()
          resolve false
        ), 15000
        @sleeper = ->
          clearTimeout timeout
          resolve true
    @ctrl.enqueue data

  resume: ->
    if @sleeper
      @sleeper()
      @sleeper = null

  onprogress: (status, progress) ->
    @port.postMessage type: 'progress', param: { status, progress }

  finish: ->
    @ctrl.close()
    @port.postMessage type: 'end'

  error: (e) ->
    @ctrl.error()
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

  respond: ->
    stream = new ReadableStream
      start: (ctrl) =>
        @download ctrl
        return # not to return promise
      pull: => @resume()
      cancel: => @cancel()

    new Response stream, headers:
      'Content-Type': @meta.type or 'application/octet-stream'
      'Content-Length': @meta.size
      'Content-Disposition': 'attachment'
      'X-Download-Options': 'noopen'
      'X-Content-Type-Options': 'nosniff'
      # Last-Modified

  download: (ctrl) ->
    await @crypto.init @secret
    @crypto.set_salt @salt
    @decrypter = new StreamDecrypter
      id: @id
      crypto: @crypto
      token: @token
      meta: @meta
      signature: @signature
      ctrl: ctrl
      port: @port
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

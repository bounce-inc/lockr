import Crypto from './crypto'
import decrypt from './decrypt'
import Queue from './queue'

downloads = {}
last_id = 0

class StreamController
  constructor: (@queue, @port) ->
    @timer = null

  pull: (ctrl) ->
    try
      data = await @queue.read()
    catch e
      ctrl.error()
      unless e.message == 'CANCEL'
        @port.postMessage type: 'error', param:
          message: e.message
          detail: e.detail
          status: e.status
      return

    if data.length == 0
      clearTimeout @timer if @timer
      ctrl.close()
      @port.postMessage type: 'end'
    else
      ctrl.enqueue data

      # Chrome doesn't call cancel so use timeout
      clearTimeout @timer if @timer
      @timer = setTimeout (=>
        @cancel()
        ctrl.error()
      ), 15 * 1000

  cancel: ->
    @queue.error new Error 'CANCEL'
    clearTimeout @timer if @timer

class Download
  constructor: (params, port) ->
    Object.assign @, params
    @port = port
    @crypto = new Crypto

  download: ->
    await @crypto.init @secret
    @crypto.set_salt @salt
    @queue = decrypt
      id: @id
      crypto: @crypto
      token: @token
      meta: @meta
      signature: @signature
      port: @port
      onprogress: (status, progress) ->
        @port.postMessage type: 'progress', param: { status, progress }

  respond: ->
    ctrl = new StreamController @queue, @port
    stream = new ReadableStream ctrl

    new Response stream, headers:
      'Content-Type': @meta.type or 'application/octet-stream'
      'Content-Length': @meta.size
      'Content-Disposition': 'attachment'
      'X-Download-Options': 'noopen'
      'X-Content-Type-Options': 'nosniff'
      # Last-Modified

  cancel: ->
    @queue?.error new Error 'CANCEL'

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
        downloads[id] = download = new Download param, port
        await download.download()
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

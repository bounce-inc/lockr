import Crypto from './crypto'
import Hmac from './hmac'
import QueuedWebSocket from './ws-queue'
import Zip from './zip'
import api, { set_api_host, reset_api_host, get_ws_prefix } from './api'
import { b64encode, join_bytes } from './encode'
import { sleep } from './util'
import { file_reader, block_aligner } from './queue'
import { event } from './ga'

export default class Upload
  @create: (files, args...) ->
    if files.length == 1
      new UploadSingle files, args...
    else
      new UploadZip files, args...

  constructor: (@files, @info, @block_size, @onprogress) ->
    @onprogress 'query'
    @crypto = new Crypto
    @canceled = false

  start: ->
    await @crypto.init()
    @id = await @crypto.get_upload_id()

    @total_size = @get_size()
    blocks = Math.ceil(@total_size / @block_size)
    paddings = blocks * 16
    @enc_size = Math.floor((@total_size + paddings) / 16) * 16

    event 'upload', 'start', @enc_size

    res = await api 'PUT', "/uploads/#{@id}", json:
      enc_size: @enc_size
      has_password: !! @info.password
      max_downloads: @info.count
      period: @info.period

    @token = res.token
    @crypto.set_salt res.salt
    set_api_host res.host
    if @info.password
      await @crypto.set_password @info.password
    @hmac = new Hmac await @crypto.get_sign_key()

    @read_queue = @open()

  upload: ->
    try
      await @start()

      ws = new QueuedWebSocket
      await ws.open "#{get_ws_prefix()}/upload"
      await ws.write @token

      await @send_body ws
      return if @canceled

      await @finish()

      event 'upload', 'complete', @enc_size

      @crypto.get_b64secret()
    catch e
      event 'upload', 'error', @enc_size
      throw e
    finally
      reset_api_host()

  send_body: (ws) ->
    last_progress = last_report = Date.now()
    size = 0
    block_num = 0
    buffered = 0
    progress = 0
    @onprogress 'upload', 0
    until @canceled
      msg = null
      if buffered >= 10
        msg = await ws.read()
      break if @canceled
      if msg
        if msg == 'ACK'
          buffered--
          progress += @block_size
          now = Date.now()
          if now >= last_progress + 33
            last_progress = now
            @onprogress 'upload', progress / @total_size
        else
          throw new Error "Server error: #{msg}"
      data = await @read_queue.read()
      if data.length == 0
        break
      @hmac.process data
      enc_data = await @crypto.encrypt_block block_num, data
      await ws.write enc_data
      buffered++
      size += data.byteLength
      block_num++
      now = Date.now()
      if now >= last_report + 10 * 1000
        await api 'PUT', "/uploads/#{@id}/progress", json: token: @token
        last_report = now

    if @canceled
      await api 'PUT', "/uploads/#{@id}/cancel", json: token: @token
      ws.write 'CANCEL'
      ws.close()
      return

    if size != @total_size
      throw new Error 'File size changed while uploading'

    for i in [0...10]
      ws.write new Uint8Array 0

    loop
      data = await ws.read()
      if data == 'ACK'
        progress += @block_size
        @onprogress 'upload', progress / @total_size
        continue
      if data == 'OK'
        break
      throw new Error "Server error: #{data}"

  finish: ->
    @meta = @create_meta()

    api 'PUT', "/uploads/#{@id}/complete", json:
      token: @token
      metadata: await @crypto.encrypt_metadata @meta
      auth_key: await @crypto.get_b64_auth_key()
      signature: b64encode @hmac.finish().result

  cancel: ->
    @canceled = true

class UploadSingle extends Upload
  get_size: -> @files[0].size

  open: -> file_reader @files[0], @block_size

  create_meta: ->
    file = @files[0]
    name: file.name
    size: file.size
    type: file.type
    last_modified: file.lastModified

class UploadZip extends Upload
  start: ->
    @zip = new Zip @files
    super()

  get_size: -> @zip.length()

  open: -> block_aligner @zip.generate(), @block_size

  create_meta: ->
    now = new Date
    zf = (d) -> ('0' + d).slice -2
    y = now.getFullYear()
    m = zf now.getMonth() + 1
    d = zf now.getDate()
    H = zf now.getHours()
    M = zf now.getMinutes()
    S = zf now.getSeconds()
    name: "lockr_#{y}-#{m}-#{d}_#{H}-#{M}-#{S}.zip"
    size: @zip.length()
    type: 'application/zip'
    last_modified: now
    manifest:
      for file in @files
        name: file.name
        size: file.size
        type: file.type
        last_modified: file.lastModified

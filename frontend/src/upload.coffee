import api, { set_api_host, reset_api_host, get_ws_prefix } from './api'
import Crypto from './crypto'
import { sleep } from './util'
import { b64encode } from './encode'
import PromisedWebSocket from './ws-promise'
import Hmac from './hmac'

export default class Upload
  constructor: (@file, @info, @block_size, @onprogress) ->
    @onprogress 'query'
    @crypto = new Crypto
    @canceled = false

  start: ->
    await @crypto.init()
    @id = await @crypto.get_upload_id()

    blocks = Math.ceil(@file.size / @block_size)
    paddings = blocks * 16
    enc_size = Math.floor((@file.size + paddings) / 16) * 16

    res = await api 'PUT', "/uploads/#{@id}", json:
      enc_size: enc_size
      has_password: !! @info.password
      max_downloads: @info.count
      period: @info.period

    @token = res.token
    @crypto.set_salt res.salt
    set_api_host res.host
    if @info.password
      await @crypto.set_password @info.password
    @hmac = new Hmac await @crypto.get_sign_key()

  upload: ->
    try
      await @start()

      ws = new PromisedWebSocket "#{get_ws_prefix()}/upload"
      await ws.open()
      await ws.send @token

      await @send_body ws
      return if @canceled

      await @finish ws
      @crypto.get_b64secret()
    finally
      reset_api_host()

  send_body: (ws) ->
    last_report = Date.now()
    offset = 0
    block_num = 0
    buffered = 0
    progress = 0
    until @canceled
      msg = null
      if buffered < 10
        msg = ws.nonblocking_receive()
      else
        msg = await ws.receive()
      break if @canceled
      if msg
        if msg == 'ACK'
          buffered--
          progress += @block_size
          @onprogress 'upload', offset / @file.size
        else
          throw new Error "Server error: #{error}" if error
      data = await @read_file offset
      if data.length == 0
        break
      @hmac.process data
      enc_data = await @crypto.encrypt_block block_num, data
      await ws.send enc_data
      buffered++
      offset += @block_size
      block_num++
      now = Date.now()
      if now >= last_report + 10 * 1000
        api 'PUT', "/uploads/#{@id}/progress", json: token: @token
        last_report = now

    if @canceled
      api 'PUT', "/uploads/#{@id}/cancel", json: token: @token
      await ws.send 'CANCEL'
      ws.close()
      return

    await ws.send new Uint8Array 0

    loop
      data = await ws.receive()
      if data == 'ACK'
        progress += @block_size
        @onprogress 'upload', offset / @file.size
        continue
      if data == 'OK'
        break
      throw new Error "Server error: #{data}"

  finish: (ws) ->
    @onprogress 'query'
    meta = await @crypto.encrypt_metadata
      name: @file.name
      size: @file.size
      type: @file.type
      last_modified: @file.lastModified

    api 'PUT', "/uploads/#{@id}/complete", json:
      token: @token
      metadata: meta
      auth_key: await @crypto.get_b64_auth_key()
      signature: b64encode @hmac.finish().result

  read_file: (offset) ->
    new Promise (resolve, reject) =>
      blob = @file.slice offset, offset + @block_size
      reader = new FileReader
      reader.onload = -> resolve new Uint8Array reader.result
      reader.onerror = -> reject reader.error
      reader.readAsArrayBuffer blob

  cancel: ->
    @canceled = true

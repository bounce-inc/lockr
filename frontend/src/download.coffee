import Crypto from './crypto'
import api from './api'
import { sleep, has_service_worker, ws_url } from './util'
import Hmac from './hmac'
import { b64encode } from './encode'
import PromisedWebSocket from './ws-promise'
import Decrypter from './decrypter'

save_url = (url, filename) ->
  a = document.createElement 'a'
  a.href = url
  a.download = filename
  document.body.appendChild a
  a.click()
  a.remove()

export default class Download
  @create: ->
    if has_service_worker
      new DownloadStream
    else
      new DownloadBlob

  set_secret: (secret) ->
    @crypto = new Crypto
    await @crypto.init secret
    @secret = secret

  get_file_info: (password) ->
    @upload_id or= await @crypto.get_upload_id()

    unless @nonce
      res = await api 'GET', "/downloads/#{@upload_id}"
      @nonce = res.nonce
      @has_password = res.has_password
      @crypto.set_salt res.salt
      @salt = res.salt

    if @has_password
      return has_password: true unless password
      await @crypto.set_password password

    sign = await @crypto.sign_nonce @nonce
    res = await api 'POST', "/downloads/#{@upload_id}", json:
      signature: sign
      nonce: @nonce
    @id = res.id
    @signature = res.signature
    @block_size = res.block_size
    @token = res.token

    @meta = await @crypto.decrypt_metadata res.metadata

    name: @meta.name
    size: @meta.size
    type: @meta.type
    lastModified: @meta.last_modified
    manifest: @meta.manifest

class BlobDecrypter extends Decrypter
  constructor: (params) ->
    super()
    Object.assign @, params
    @array = []

  push: (data) -> @array.push new Blob [data]
  
  error: (e) -> throw e unless e.message == 'CANCEL'

  finish: ->
    await sleep 1
    blob = new Blob @array, type: @meta.type
    if navigator.msSaveBlob
      navigator.msSaveBlob blob, @meta.name
    else
      url = URL.createObjectURL blob
      save_url url, @meta.name
      setTimeout (-> URL.revokeObjectURL url), 60*1000

class DownloadBlob extends Download
  download: (onprogress) ->
    @decrypter = new BlobDecrypter
      id: @id
      crypto: @crypto
      token: @token
      meta: @meta
      onprogress: onprogress
      signature: @signature
    @decrypter.decrypt()

  cancel: -> @decrypter.cancel()

class DownloadStream extends Download
  download: (onprogress) ->
    try
      unless navigator.serviceWorker.controller
        console.log 'awaiting sw activation'
        await navigator.serviceWorker.ready

      params =
        id: @id
        secret: @secret
        salt: @salt
        signature: @signature
        block_size: @block_size
        token: @token
        meta: @meta

      [@sw_id, port] = await @send_sw 'start', null, params

      filename = encodeURIComponent @meta.name
      url = "/service-worker-internal/decrypter/#{@sw_id}/#{filename}"
      if /Firefox/.test navigator.userAgent
        save_url url, @meta.name
      else
        location.href = url

      @ping = setInterval (=> @send_sw 'ping'), 1000

      await new Promise (resolve, reject) =>
        port.onmessage = (ev) =>
          { type, param } = ev.data
          switch type
            when 'progress'
              { status, progress } = param
              onprogress status, progress
            when 'end'
              onprogress 'completed'
              resolve()
            when 'cancel'
              onprogress 'canceled'
              resolve()
            when 'error'
              error = new Error
              error.message = param.message
              error.status = param.status
              reject error
            else
              reject new Error "Unknown notification #{type}"
      clearInterval @ping
    catch e
      @cancel()
      throw e

  send_sw: (command, id, param, port) ->
    new Promise (resolve, reject) ->
      chan = new MessageChannel
      chan.port1.onmessage = (ev) ->
        if ev.data?.error
          reject new Error ev.data.error
        else
          retval =
            if command == 'start'
              [ev.data, chan.port1]
            else
              ev.data
          resolve retval
      ports = [chan.port2]
      if port
        ports.push port
      ctrl = navigator.serviceWorker.controller
      ctrl.postMessage command: command, id: id, param: param, ports

  cancel: ->
    await @send_sw 'cancel', @sw_id
    clearInterval @ping

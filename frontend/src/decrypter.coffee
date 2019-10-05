import Hmac from './hmac'
import { b64encode } from './encode'
import QueuedWebSocket from './ws-queue'
import api, { set_api_host, reset_api_host, get_ws_prefix } from './api'

export default class Decrypter
  constructor: ->
    @canceled = false

  decrypt: ->
    try
      block_num = 0
      progress = 0
      res = await api 'PUT', "/downloads/#{@id}/start", json: token: @token
      @token = res.token
      set_api_host res.host
      hmac = new Hmac await @crypto.get_sign_key()
      ws = new QueuedWebSocket
      await ws.open "#{get_ws_prefix()}/download"
      await ws.write @token
      loop
        if @canceled
          throw new Error 'CANCEL'
        now = Date.now()
        data = await ws.read()
        if typeof data == 'string'
          if data == 'EOF'
            break
          throw new Error "Server error: #{data}"
        await ws.write 'ACK'
        enc_data = new Uint8Array data
        dec_data = await @crypto.decrypt_block block_num, enc_data
        await @push dec_data
        hmac.process dec_data
        progress += dec_data.length
        @onprogress 'download', progress / @meta.size
        block_num++
      sig = b64encode hmac.finish().result
      if sig != @signature
        throw new Error 'signature'
      ws.close()
      @onprogress 'completed'
      await @finish()
    catch e
      if e.message == 'CANCEL'
        @onprogress 'canceled'
      else
        console.error e
      try
        await ws?.write 'CANCEL'
        ws?.close()
      catch
      @error e
    finally
      reset_api_host()

  cancel: ->
    @canceled = true

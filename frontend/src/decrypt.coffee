import Hmac from './hmac'
import { b64encode } from './encode'
import Queue from './queue'
import QueuedWebSocket from './ws-queue'
import api, { set_api_host, reset_api_host, get_ws_prefix } from './api'

export default (params) ->
  queue = new Queue
  do ->
    try
      block_num = 0
      progress = 0
      last_progress = Date.now()
      res = await api 'PUT', "/downloads/#{params.id}/start", json:
        token: params.token
      token = res.token
      set_api_host res.host
      hmac = new Hmac await params.crypto.get_sign_key()
      ws = new QueuedWebSocket
      await ws.open "#{get_ws_prefix()}/download"
      ws.write token
      loop
        data = await ws.read()
        if typeof data == 'string'
          if data == 'EOF'
            break
          throw new Error "Server error: #{data}"
        ws.write 'ACK'
        enc_data = new Uint8Array data
        dec_data = await params.crypto.decrypt_block block_num, enc_data
        await queue.write dec_data
        hmac.process dec_data
        progress += dec_data.length
        now = Date.now()
        if now >= last_progress + 33
          last_progress = now
          params.onprogress 'download', progress / params.meta.size
        block_num++
      sig = b64encode hmac.finish().result
      if sig != params.signature
        throw new Error 'signature'
      ws.close()
      params.onprogress 'completed'
      queue.write new Uint8Array 0
    catch e
      if e.message == 'CANCEL'
        params.onprogress 'canceled'
      else
        console.error e
      try
        ws?.write 'CANCEL'
        ws?.close()
      catch
      queue.error e
    finally
      reset_api_host()
  queue

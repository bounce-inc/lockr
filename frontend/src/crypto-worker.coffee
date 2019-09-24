import AsmCrypto from './asm-crypto'

addEventListener 'message', (ev) ->
  { seq, cmd, param } = ev.data
  try
    result =
      switch cmd
        when 'get_rand' then AsmCrypto.get_rand()
        when 'hmac_key' then AsmCrypto.hmac_key param
        when 'hmac' then AsmCrypto.hmac param.key, param.data
        when 'stretch'
          AsmCrypto.stretch param.password, param.salt, param.count
        when 'enc_key' then AsmCrypto.enc_key param
        when 'encrypt' then AsmCrypto.encrypt param.key, param.iv, param.data
        when 'decrypt' then AsmCrypto.decrypt param.key, param.iv, param.data
        else throw new Error "Invalid command #{cmd}"
    postMessage { seq, result }
  catch error
    postMessage { seq, error: error.message }
    throw error # for debug

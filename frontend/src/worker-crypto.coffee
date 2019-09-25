import CryptoWorker from 'worker-loader?name=js/worker.[hash:8].js!./crypto-worker'

export default ->
  worker = new CryptoWorker

  seqno = 0
  resolvers = {}

  worker.onmessage = (e) ->
    { seq, result, error } = e.data
    if error
      resolvers[seq].reject new Error error
    else
      resolvers[seq].resolve result

  send = (cmd, param) ->
    seq = ++seqno
    worker.postMessage { seq, cmd, param }
    new Promise (resolve, reject) -> resolvers[seq] = { resolve, reject }

  get_rand: (len) -> send 'get_rand', len
  hmac_key: (key) -> key
  hmac: (key, data) -> send 'hmac', { key, data }
  stretch: (password, salt, count) -> send 'stretch', { password, salt, count }
  enc_key: (key) -> key
  encrypt: (key, iv, data) -> send 'encrypt', { key, iv, data }
  decrypt: (key, iv, data) -> send 'decrypt', { key, iv, data }

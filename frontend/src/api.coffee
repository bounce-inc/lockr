export class ConnectionError extends Error
  constructor: ->
    super 'connection'

export class APIError extends Error
  constructor: (status, detail) ->
    super detail
    @status = status

sleep = ->
  msec = Math.random() * 2000
  new Promise (resolve) -> setTimeout resolve, msec

DEFAULT_PREFIX = '/api'

api_prefix = DEFAULT_PREFIX

export default (method, url, options={}) ->
  if typeof fetch == 'undefined'
    await import('whatwg-fetch')
  tries = 0
  max_tries = 5
  url = api_prefix + url
  headers = { options.headers... }
  if options.json
    body = JSON.stringify options.json
    headers['Content-Type'] = 'application/json'
  else
    body = null

  loop
    try
      res = await fetch url, {
        method
        headers
        body
        credentials: 'include'
      }
    catch e
      if ++tries < max_tries
        await sleep()
        continue
      throw e

    data =
      if res.headers.get('Content-Type') == 'application/json'
        await res.json()
      else
        await res.text()

    if res.status < 400
      return data

    if res.status == 503 and data.error == 'maintenance'
      throw new Error 'maintenance'

    if res.status >= 500 and ++tries < max_tries
      await sleep()
      continue

    throw new APIError res.status, data?.error or ''

  return # disable returning array

export set_api_host = (host) ->
  api_prefix = "#{location.protocol}//#{host}/api"

export reset_api_host = -> api_prefix = DEFAULT_PREFIX

export get_ws_prefix = ->
  if api_prefix == DEFAULT_PREFIX
    scheme = location.protocol.replace 'http', 'ws'
    host = location.host
    "#{scheme}//#{host}"
  else
    api_prefix.replace(/^http/, 'ws').replace(/api$/, 'ws')


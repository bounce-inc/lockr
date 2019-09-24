KEY = 'lockr_secrets'

export default secrets =
  secrets: do ->
    data = localStorage[KEY]
    if data
      JSON.parse data
    else
      {}

  add: (id, secret, expires) ->
    @secrets[id] = [secret, expires]
    @save()

  save: ->
    localStorage[KEY] = JSON.stringify @secrets

  get: (id) ->
    secret_exp = @secrets[id]
    if secret_exp
      secret_exp[0]
    else
      null

  forget: ->
    forgot = false
    now = Date.now()
    for key, [secret, expires] of @secrets
      if expires < now
        delete @secrets[key]
        forgot = true
    forgot

secrets.forget() and secrets.save()

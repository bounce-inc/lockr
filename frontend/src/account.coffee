import api from './api'
import { show_error } from './error'

export default account =
  user: null

  get: ->
    try
      @user = await api 'GET', '/session'
    catch e
      show_error e

account.get()

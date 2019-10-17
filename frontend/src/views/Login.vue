<template lang="pug">
ActiveBox.box
  form(@submit.prevent="submit")
    .field
      label {{ t('login_email') }}
      TextBox.input(
        type="text"
        v-model.trim="email"
        autofocus
      )
    .field
      label {{ t('app_password') }}
      TextBox.input(
        type="password"
        v-model.trim="password"
      )
    .spinner(v-if="busy")
      Spinner
    ActionBar(v-else)
      Button(primary)
        | {{ t('login_btn') }}
</template>

<script lang="coffee">
import ActionBar from '../components/ActionBar'
import ActiveBox from '../components/ActiveBox'
import Button from '../components/Button'
import Spinner from '../components/Spinner'
import TextBox from '../components/TextBox'
import api from '../api'
import account from '../account'
import { show_error } from '../error'
import { t } from '../i18n'
import { sign_with_password } from '../password'

export default
  components: {
    ActionBar
    ActiveBox
    Button
    Spinner
    TextBox
  }
  props:
    url:
      type: String
      default: '/'
  data: ->
    email: ''
    password: ''
    busy: false
  methods:
    t: t
    submit: ->
      try
        @busy = true
        email = encodeURIComponent @email
        { salt, nonce } = await api 'GET', "/session/#{email}"
        sign = await sign_with_password @password, salt, nonce
        await api 'POST', '/session', json:
          email: @email
          nonce: nonce
          signature: sign
      catch e
        if e.status == 401
          e = new Error 'login'
        show_error e
        return
      finally
        @busy = false
      account.get()
      @$router.push @url
</script>

<style scoped lang="stylus">
.box
  margin 3rem auto
  width 28.4rem
.field:not(:first-child)
  margin-top 1.2rem
label
  display block
  font-weight bold
.input
  width 100%
.spinner
  margin-top 1.6rem
</style>

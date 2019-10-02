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
    ActionBar
      Button(primary)
        | {{ t('login_btn') }}
</template>

<script lang="coffee">
import ActionBar from '../components/ActionBar'
import ActiveBox from '../components/ActiveBox'
import Button from '../components/Button'
import TextBox from '../components/TextBox'
import api from '../api'
import { show_error } from '../error'
import { t } from '../i18n'

export default
  components: {
    ActionBar
    ActiveBox
    Button
    TextBox
  }
  data: ->
    email: ''
    password: ''
  methods:
    t: t
    submit: ->
      try
        await api 'POST', '/session', json:
          email: @email
          password: @password
      catch e
        if e.status == 401
          e = new Error 'login'
        show_error e
        return
      @$router.push '/'
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
</style>

<template lang="pug">
#app(
  :class="{ 'has-mouse': has_mouse, 'notice-shown': notice_shown }"
  @touchstart="has_mouse = false"
)
  header
    h1
      router-link(to="/")
        LockIcon
        | Lockr
        sub.beta BETA 
    .catch {{ i18n.t('app_catch') }}

  p(v-if="!capable") {{ i18n.t('app_old_browser_warn') }}
  p(v-else-if="error_status.maintenance") {{ i18n.t('app_maintenance') }}
  router-view(v-else)
  .filler
  Footer
  CookieNotice(@show="notice_shown = true" @hide="notice_shown = false")
  ErrorModal
</template>

<script lang="coffee">
import CookieNotice from './components/CookieNotice'
import ErrorModal from './components/ErrorModal'
import Footer from './components/Footer'
import LockIcon from 'vue-material-design-icons/Lock'
import api from './api'
import i18n from './i18n'
import { error_status, show_error } from './error'

export default
  components: {
    LockIcon
    CookieNotice
    ErrorModal
    Footer
  }
  data: ->
    has_mouse: true
    capable: window.Worker and window.WebSocket
    i18n: i18n
    error_status: error_status
    notice_shown: false
  created: ->
    try
      await api 'GET', '/status'
    catch e
      show_error e
</script>

<style lang="stylus">
html
  font-size 62.5% // 1rem == 10px for default setting (16px) of most browsers
  font-family 'Trebuchet MS', Helvetica, Arial, sans-serif
  background #333
  color #eee
  line-height 1.5
  -webkit-font-smoothing antialiased
  -moz-osx-font-smoothing grayscale
  font-feature-settings "palt"
  overflow-wrap break-word
  -webkit-overflow-scrolling touch
  &[lang="ja"]
    font-family 'Hiragino Sans', 'Hiragino Kaku Gothic Pro', 'Yu Gothic Medium',
      Meiryo, sans-serif
  height 100%

body
  font-size 1.6rem // 16px
  height 100%

a
  color inherit

#app
  min-height 100%
  display flex
  flex-direction column
  justify-content space-between

  max-width 80rem
  padding 0.8rem
  margin 0 auto

  transition padding-bottom 1s cubic-bezier(.7, 0, .3, 1)
  &.notice-shown
    padding-bottom 6.4rem

  header
    margin 1.6rem 0
    h1
      display inline-block
      font-family 'Helvetica Neue', Helvetica, Arial, sans-serif
      a
        text-decoration none
      .beta
        opacity 0.5
        font-size 1.6rem
    .catch
      display inline-block
      margin-left 0.8rem

  .filler
    flex-grow 1
</style>

<template lang="pug">
transition(appear)
  .notice(v-if="show")
    p
      CookieIcon
      span(v-html="t('cookie_notice')")
    Button.button(@click="close") OK
</template>

<script lang="coffee">
import Button from './Button'
import CookieIcon from 'vue-material-design-icons/Cookie'
import { t } from '../i18n'

KEY = 'lockr_agreement'

export default
  components: { Button, CookieIcon }
  data: ->
    show: false
  methods:
    t: t
    close: ->
      localStorage[KEY] = 'OK'
      @show = false
    set_show: ->
      setTimeout (=>
        if @$route.path not in ['/terms', '/privacy']
          @show = not localStorage[KEY]
      ), 1000
  mounted: -> @set_show()
  watch:
    show: (val) ->
      if val
        @$emit 'show'
      else
        @$emit 'hide'
    $route: -> @set_show()
</script>

<style scoped lang="stylus">
.notice
  position fixed
  bottom 0
  left 0
  width 100vw
  display flex
  justify-content center
  align-items center
  background: #222
  height 6.4rem
  padding 0.8rem
  p
    font-size 1.4rem
    opacity 0.7
  .button
    margin-left 1.6rem

.v-enter-active, .v-leave-active
  transition 1s cubic-bezier(.7, 0, .3, 1)

.v-enter, .v-leave-to
  transform translateY(100%)

@media (max-width: 480px)
  .notice p
    font-size 1.2rem
    line-height 1.6rem
</style>

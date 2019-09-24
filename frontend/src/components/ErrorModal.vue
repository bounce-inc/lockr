<template lang="pug">
.error-modal(v-if="error.title")
  .error
    .title
      ErrorIcon.icon
      | 
      | {{ error.title }}
    .detail(v-if="error.detail") {{ error.detail }}
    .action
      Button.button(@click="close_error") {{ t('app_btn_close') }}
</template>

<script lang="coffee">
import ErrorIcon from 'vue-material-design-icons/AlertCircle'
import Button from './Button'
import { t } from '../i18n'
import { error_status } from '../error'

export default
  components: { ErrorIcon, Button }
  data: ->
    error: error_status
  methods:
    t: t
    close_error: ->
      onclose = @error.onclose
      @error.clear()
      onclose() if onclose
</script>

<style scoped lang="stylus">
.error-modal
  position fixed
  width 100%
  height 100%
  left 0
  top 0
  background rgba(0, 0, 0, .5)
  display flex
  justify-content center
  align-items center
  .error
    max-width 80rem
    padding 1.6rem
    margin .8rem
    background #333
    border 0.2rem solid #c33
    border-radius .8rem
    display flex
    flex-direction column
    justify-content center
    align-items center
    .title
      display flex
      align-items center
      font-weight bold
      font-size 2.0rem
      .icon
        font-size 3.2rem
        margin-right .8rem
    .action
      margin-top 2.4rem
</style>

<!-- without scope -->
<style lang="stylus">
.error-modal .error .title .icon svg
  bottom 0
</style>

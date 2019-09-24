<template lang="pug">
.container(v-if="show")
  p 
    NotificationIcon
    | {{ t('notification_description') }}
  Button(@click="enable") {{ t('notification_btn_enable') }}
</template>

<script lang="coffee">
import Button from './Button'
import NotificationIcon from 'vue-material-design-icons/Bell'
import { t } from '../i18n'

export default
  components: { Button, NotificationIcon }
  data: ->
    show:
      window.Notification?.permission == 'default' and
      not /Android/.test navigator.userAgent
  methods:
    t: t
    enable: ->
      Notification.requestPermission => @show = false
</script>

<style scoped lang="stylus">
.container
  margin-top 2rem
  text-align center
  p
    margin-bottom .8rem
</style>

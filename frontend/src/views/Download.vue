<template lang="pug">
.container
  FileInfo.fileinfo(
    v-if="file_info"
    :file="file_info"
    :zip="!!file_info.manifest"
  )
  FileList(v-if="file_info && file_info.manifest" :files="file_info.manifest")

  .error-frame(v-if="large_file") {{ t('download_large_file_warn') }}

  form(v-if="status == 'form'" @submit.prevent="submit")
    span(v-if="has_password")
      label {{ t('app_password') }}:
      TextBox(
        type="password"
        v-model.trim="password"
        autofocus
      )
    Button.button(primary)
      DownloadIcon
      | 
      | {{ t('download_btn_download') }}
    .error(v-if="wrong_password")
      ErrorIcon.icon
      | {{ t('download_wrong_password') }}

    .mobile(v-if="!is_mobile")
      .qr(v-html="qr")
      p モバイルでダウンロード

  .error-frame(v-if="status == 'error'")
    span(v-if="error == 'downloads'")
      | {{ t('app_deleted_downloads') }}
    span(v-if="error == 'expired'")
      | {{ t('app_deleted_expired') }}
    span(v-if="error == 'user'")
      | {{ t('app_deleted_user') }}
    span(v-if="error == 'banned'")
      | {{ t('app_deleted_banned') }}
    span(v-if="error == 'conflict'")
      | {{ t('download_conflict') }}

  .downloading(v-if="status == 'download'")
    .status {{ t('download_downloading') }}
    ProgressBar(:progress="progress")
    CancelButton(@click="cancel") {{ t('app_cancel') }}

  Spinner(v-if="status == 'query'")

  .completed(v-if="status == 'completed'") {{ t('download_completed') }}
  .canceled(v-if="status == 'canceled'") {{ t('download_canceled') }}
  .win-warn(v-if="win_warn")
    ErrorIcon
    span &nbsp;
    span(v-html="t('download_win_warn')")

  NotificationRequest(v-if="status == 'download'")

  .learn(v-if="status != 'download'")
    router-link(to="/") {{ t('download_learn') }}

  GlobalEvents(@hashchange="start" target="window")
</template>

<script lang="coffee">
import Button from '../components/Button'
import CancelButton from '../components/CancelButton'
import Download from '../download'
import DownloadIcon from 'vue-material-design-icons/CloudDownload'
import ErrorIcon from 'vue-material-design-icons/AlertCircle'
import FileInfo from '../components/FileInfo'
import FileList from '../components/FileList'
import GlobalEvents from 'vue-global-events'
import NotificationRequest from '../components/NotificationRequest'
import ProgressBar from '../components/ProgressBar'
import Spinner from '../components/Spinner'
import TextBox from '../components/TextBox'
import notification from '../notification'
import qrcode from 'pure-svg-code/qrcode'
import { has_service_worker, is_mobile } from '../util'
import { show_error } from '../error'
import { t } from '../i18n'

export default
  components: {
    Button
    CancelButton
    DownloadIcon
    ErrorIcon
    FileInfo
    FileList
    GlobalEvents
    NotificationRequest
    ProgressBar
    Spinner
    TextBox
  }

  data: ->
    error: null
    file_info: null
    has_password: false
    password: ''
    progress: 0
    status: 'query'
    wrong_password: false
    is_mobile: is_mobile

  computed:
    large_file: ->
      @file_info?.size > 1024 * 1024 * 1024 and not has_service_worker
    win_warn: ->
      m = /NT ([\d.]+)/.exec navigator.userAgent
      return false unless m
      win_ver = m[1] + 0
      return false if win_ver > 6.1
      return false unless @file_info?.manifest
      for file in @file_info.manifest
        if /[^\x20-\x7f]/.test file.name
          return true
      false
    qr: ->
      qrcode
        content: location.href
        padding: 4
        width: 128
        height: 128

  mounted: ->
    @start()

  methods:
    t: t

    dl_error: (e) ->
      return false unless e.status == 410 or e.status == 409
      @status = 'error'
      @error = e.message
      true

    start: ->
      try
        @status = 'query'
        @file_info = null
        @has_password = null
        @wrong_password = null
        @progress = 0

        secret = location.hash.slice 1
        @download = Download.create()
        await @download.set_secret secret
        try
          info = await @download.get_file_info()
        catch e
          return if @dl_error e
          @status = null
          throw e
        if info.has_password
          @has_password = true
        else
          @file_info = info
        @status = 'form'
      catch e
        console.error e
        show_error e, @start

    submit: ->
      try
        if @has_password and not @password
          return
        if @file_info == null
          @wrong_password = false
          @status = 'query'
          try
            info = await @download.get_file_info @password
          catch e
            if e.status == 401
              @wrong_password = true
              @status = 'form'
              return
            else
              throw e
          @file_info = info
        @status = 'download'
        await @download.download (s, p) =>
          if @download
            @status = s
            @progress = p
        @download = null
        if @status == 'completed'
          notification t('notification_download'), @file_info.name
      catch e
        return if @dl_error e
        console.error e
        show_error e, @start

    cancel: ->
      @download?.cancel()
      @download = null
      @status = 'canceled'
</script>

<style scoped lang="stylus">
form
  margin 2rem 0
  text-align center
  label
    font-weight bold
    margin-right 0.8rem
  .button
    margin 0.8rem
  .icon
    font-size 2.4rem
    vertical-align -0.3rem

.error-frame
  margin 0.8rem 0
  border 0.2rem solid #ccc
  border-radius 0.8rem
  padding 2rem
  text-align center

.win-warn
  margin 2rem 0
  text-align center

.learn
  text-align center
  margin-top 2rem

.mobile
  margin 3.2rem 0
  p
    font-size 1.4rem
    opacity 0.7
</style>

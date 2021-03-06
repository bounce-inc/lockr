<template lang="pug">
.container
  FileInfo(v-if="meta" :file="meta" :zip="!!meta.manifest")
  .noinfo(v-else)
    .title
      QuestionIcon
      | 
      | {{ t('uploadedfile_noinfo_title') }}
    .desc {{ t('uploadedfile_noinfo_desc') }}
  FileList(v-if="meta && meta.manifest" :files="meta.manifest")

  .status(v-if="info")
    span(v-if="info.status != 'deleted'")
      | {{ t('uploadedfile_completed') }}
    span(v-if="info.reason == 'downloads'")
      | {{ t('app_deleted_downloads') }}
    span(v-if="info.reason == 'expired'")
      | {{ t('app_deleted_expired') }}
    span(v-if="info.reason == 'user'")
      | {{ t('app_deleted_user') }}
    span(v-if="info.reason == 'banned'")
      | {{ t('app_deleted_banned') }}

  ActiveBox.box(v-if="secret && info && info.status != 'deleted'")
    .label
      LinkIcon
      | 
      | {{ t('uploadedfile_label_link') }}:
    .link(@click="select_url") {{ url }}
    .notice
      AlertIcon
      | {{ t('uploadedfile_link_notice') }}

    ActionBar
      template(v-slot:left)
        Button(@click="remove" v-if="!deleting")
          DeleteIcon
          | {{ t('app_delete') }}
        Spinner(v-else)
      Button(@click="copy" :primary="!copied")
        CopyIcon(v-if="!copied")
        | 
        span(v-if="copied") {{ t('uploadedfile_copied') }}
        span(v-else) {{ t('uploadedfile_copy') }}

  .box.delete-only(v-if="!secret && info && info.status != 'deleted'")
    Button(@click="remove" v-if="!deleting")
      DeleteIcon
      | {{ t('app_delete') }}
    Spinner(v-else)


  .info(v-if="info")
    .counts
      span(:title="t('uploadedfile_dl_progress')")
        ProgressIcon.icon(:title="t('uploadedfile_dl_progress')")
        | {{ info.dl_progress }} 
      span(:title="t('uploadedfile_dl_failure')")
        FailIcon.icon(:title="t('uploadedfile_dl_failure')")
        | {{ info.dl_failure }} 
      span(:title="t('uploadedfile_dl_success')")
        CheckIcon.icon(:title="t('uploadedfile_dl_success')")
        | {{ info.dl_success }} 
      span(:title="t('uploadedfile_dl_max')")
        | / {{ info.max_downloads }}
      span.remaining(v-if="remaining_time")
        | {{ t('app_progress', { time: remaining_time}) }}

  .upload-more
    router-link(:to="{ name: 'upload' }") {{ t('uploadedfile_more') }}
</template>

<script lang="coffee">
import ActionBar from '../components/ActionBar'
import ActiveBox from '../components/ActiveBox'
import AlertIcon from 'vue-material-design-icons/AlertCircle'
import Button from '../components/Button'
import CheckIcon from 'vue-material-design-icons/CheckCircleOutline'
import CopyIcon from 'vue-material-design-icons/ContentCopy'
import Crypto from '../crypto'
import DeleteIcon from 'vue-material-design-icons/Delete'
import FailIcon from 'vue-material-design-icons/CloseCircleOutline'
import FileInfo from '../components/FileInfo'
import FileList from '../components/FileList'
import LinkIcon from 'vue-material-design-icons/Link'
import ProgressIcon from 'vue-material-design-icons/ProgressDownload'
import QuestionIcon from 'vue-material-design-icons/FileQuestion'
import QueuedWebSocket from '../ws-queue'
import Spinner from '../components/Spinner'
import api, {
  ConnectionError
  get_ws_prefix
  reset_api_host
  set_api_host
} from '../api'
import clipboard_copy from 'clipboard-copy'
import i18n, { t } from '../i18n'
import metadata from '../metadata'
import { human_readable_time } from '../ui-util'
import { show_error } from '../error'
import { sleep } from '../util'

export default
  components: {
    ActionBar
    ActiveBox
    AlertIcon
    Button
    CheckIcon
    CopyIcon
    DeleteIcon
    FailIcon
    FileInfo
    FileList
    LinkIcon
    ProgressIcon
    QuestionIcon
    Spinner
  }

  props:
    id:
      type: String
      required: true
    secret:
      type: String
      default: null

  data: ->
    info: null
    meta: null
    copied: false
    deleting: false
    ws: null
    expires_at: null
    remaining_time: null
    exitting: false

  computed:
    url: ->
      hosturl = location.href.split('/').slice(0, 3).join('/')
      "#{hosturl}/#{i18n.lang}/d##{@secret}"

  methods:
    t: t

    get_meta: ->
      meta = metadata.get @id
      if meta
        @meta = { meta..., lastModified: meta.last_modified }

    connect: ->
      until @exitting
        reset_api_host()
        try
          res = await api 'POST', "/watches/#{@id}"
        catch e
          if e instanceof ConnectionError
            continue
          show_error e, => @$router.push '/'
          return

        @info = res.status

        try
          set_api_host res.host
          @ws = new QueuedWebSocket
          await @ws.open "#{get_ws_prefix()}/watch"
          @ws.write res.token
          loop
            @info = JSON.parse await @ws.read()
        catch e
          if e.message not in ['websocket', 'wsclose']
            show_error e
            return

        await api 'DELETE', "/watches/#{res.id}", json:
          token: res.token

        await sleep 2000

    remove: ->
      return unless confirm t 'uploadedfile_confirm_delete'
      @deleting = true
      try
        await api 'DELETE', "/uploads/#{@id}"
      catch e
        @deleting = false
        show_error e

    select_url: (ev) ->
      range = document.createRange()
      range.selectNode ev.target
      selection = window.getSelection()
      selection.removeAllRanges()
      selection.addRange range

    copy: ->
      await clipboard_copy @url
      @copied = true
      setTimeout (=> @copied = false), 1000

    update_time: ->
      @remaining_time = null
      return unless @info
      return if @info.status == 'deleted'
      seconds = @expires_at - Date.now() / 1000
      if seconds <= 0
        @info.status = 'deleted'
        @info.reason = 'expired'
        return
      @remaining_time = human_readable_time seconds

  watch:
    info: ->
      @expires_at = Date.now() / 1000 + @info.expires_in
      @update_time()

  created: ->
    @get_meta()
    @connect()
    @timer = setInterval @update_time, 1000

  beforeDestroy: ->
    clearInterval @timer
    @exitting = true
    @ws?.close()
</script>

<style scoped lang="stylus">
.link
  display block
  width 100%
  font-size 2.0rem
  line-height 2.4rem
  white-space nowrap
  overflow-x auto
  overflow-y hidden
.noinfo
  .title
    font-size 2rem
    font-weight bold
.box
  margin 2rem 0
  .notice
    margin-top 0.8rem
    opacity 0.7
    font-size 1.4rem
.status
  font-weight bold
  margin-top 2rem
.upload-more
  margin-top 2rem
  text-align center
.counts
  .icon
    font-size 2.4rem
    vertical-align -0.3rem
  .remaining
    margin-left 1.6rem
</style>

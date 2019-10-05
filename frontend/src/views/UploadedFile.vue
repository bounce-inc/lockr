<template lang="pug">
.container
  FileInfo(v-if="meta" :file="meta" :zip="!!meta.manifest")
  .noinfo(v-if="!secret")
    .title
      QuestionIcon
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

  ActiveBox.box(v-if="info && info.status != 'deleted'")
    div(v-if="secret")
      .label
        LinkIcon
        | 
        | {{ t('uploadedfile_label_link') }}:
      .link(@click="select_url") {{ url }}
    ActionBar
      template(v-slot:left)
        Button(@click="remove" v-if="!deleting")
          DeleteIcon
          | {{ t('app_delete') }}
        Spinner(v-else)
      Button(v-if="secret" @click="copy" :primary="!copied")
        CopyIcon(v-if="!copied")
        | 
        span(v-if="copied") {{ t('uploadedfile_copied') }}
        span(v-else) {{ t('uploadedfile_copy') }}

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
import Spinner from '../components/Spinner'
import api from '../api'
import clipboard_copy from 'clipboard-copy'
import secrets from '../secrets'
import { human_readable_time } from '../ui-util'
import { show_error } from '../error'
import i18n, { t } from '../i18n'

export default
  components: {
    ActionBar
    ActiveBox
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

  data: ->
    secret: null
    info: null
    meta: null
    copied: false
    deleting: false

  computed:
    url: ->
      hosturl = location.href.split('/').slice(0, 3).join('/')
      "#{hosturl}/#{i18n.lang}/d##{@secret}"

    remaining_time: ->
      return null if @info.status == 'deleted'
      seconds = @info.expires_at - Date.now() / 1000
      return null if seconds <= 0
      human_readable_time seconds

  methods:
    t: t

    get_file_info: ->
      try
        @info = await api 'GET', "/uploads/#{@id}"
      catch e
        show_error e, => @$router.push '/'
      crypto = new Crypto
      await crypto.init @secret
      crypto.set_salt @info.salt
      @meta = await crypto.decrypt_metadata @info.metadata
      @meta.lastModified = @meta.last_modified

    update_info: ->
      @info = await api 'GET', "/uploads/#{@id}"
      if @info.status == 'deleted'
        clearInterval @interval

    remove: ->
      return unless confirm t 'uploadedfile_confirm_delete'
      @deleting = true
      try
        await api 'DELETE', "/uploads/#{@id}"
      catch e
        @deleting = false
        show_error e
      @update_info()

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

  created: ->
    @secret = secrets.get @id
    @get_file_info()
    @interval = setInterval @update_info, 10 * 1000

  beforeDestroy: ->
    clearInterval @interval
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

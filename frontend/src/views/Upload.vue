<template lang="pug">
.container
  FileInfo(v-if="file" :file="file")
  UploadInfo(v-if="upload_info" :info="upload_info")

  ActiveBox.active-box
    .chooser-box(v-show="status == 'file'")
      .instruction {{ t('home_drop_or_choose') }}
      FileChooser(v-slot="{ open }" @file-chosen="file_chosen")
        Button(primary @click="open")
          FolderIcon
          | 
          | {{ t('home_btn_choose_file') }}

    .quota(v-if="status == 'quota'")
      | {{ t('upload_quota_exceed', human_quota) }}
      ActionBar
        template(v-slot:left)
          Button(@click="init") {{ t('app_cancel') }}

    UploadForm(
      v-if="status == 'form'"
      :uploadLimits="upload_spec"
      @submit="submit"
      @cancel="init"
    )

    .uploading(v-if="status == 'upload'")
      .status {{ t('upload_uploading') }}
      ProgressBar(:progress="progress")
      CancelButton(@click="cancel") {{ t('app_cancel') }}

    Spinner(v-if="status == 'query'")

  NotificationRequest(v-if="status == 'upload'")
</template>

<script lang="coffee">
import ActionBar from '../components/ActionBar'
import ActiveBox from '../components/ActiveBox'
import Button from '../components/Button'
import CancelButton from '../components/CancelButton'
import FileChooser from '../components/FileChooser'
import FileInfo from '../components/FileInfo'
import FolderIcon from 'vue-material-design-icons/Folder'
import NotificationRequest from '../components/NotificationRequest'
import ProgressBar from '../components/ProgressBar'
import Spinner from '../components/Spinner'
import Upload from '../upload'
import UploadForm from '../components/UploadForm'
import UploadInfo from '../components/UploadInfo'
import api from '../api'
import secrets from '../secrets'
import { t } from '../i18n'
import { show_error } from '../error'
import { human_readable_size } from '../ui-util'
import notification from '../notification'

export default
  components: {
    ActionBar
    ActiveBox
    Button
    CancelButton
    FileChooser
    FileInfo
    FolderIcon
    NotificationRequest
    ProgressBar
    Spinner
    UploadForm
    UploadInfo
  }

  props:
    f:
      type: File
      default: null

  data: ->
    file: null
    status: 'file'
    upload_info: null
    upload_spec: null
    progress: 0

  computed:
    human_quota: ->
      quota: human_readable_size @upload_spec.quota
      usage: human_readable_size @upload_spec.usage

  mounted: ->
    if @f then @file_chosen @f

  methods:
    t: t

    init: ->
      @file = @upload_info = null
      @status = 'file'
      @progress = 0

    file_chosen: (file) ->
      @file = file
      try
        @status = 'query'
        @upload_spec = await api 'GET', '/uploads/info'
        if @check_quota()
          @status = 'form'
        else
          @status = 'quota'
      catch e
        console.error e
        show_error e
        @init()

    check_quota: ->
      remain = @upload_spec.quota - @upload_spec.usage
      @file.size < remain

    submit: (data) ->
      try
        @upload_info = data
        @upload = new Upload(
          @file
          @upload_info
          @upload_spec.block_size
          (status, progress) =>
            @status = status
            @progress = progress
        )
        secret = await @upload.upload()
        return unless secret
        notification t('notification_upload'), @file.name
        expires = Date.now() + (@upload_info.period + 90*24*60*60) * 1000
        secrets.add @upload.id, secret, expires
        @$router.push name: 'uploaded_file', params: id: @upload.id
      catch e
        console.error e
        show_error e
        @upload_info = null
        @status = 'form'

    cancel: ->
      @upload?.cancel()
      @upload_info = null
      @status = 'form'
</script>

<style scoped lang="stylus">
.active-box
  margin 1.6rem 0
.chooser-box
  width 100%
  display flex
  justify-content space-between
  align-items center
  .instruction
    flex-grow 1
</style>

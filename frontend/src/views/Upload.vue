<template lang="pug">
.container
  TransitionGroup(tag="div")
    FileInfo.file-info(
      v-for="file in files"
      :key="file.name"
      :file="file"
      :removable="status === 'form'"
      @remove="remove_file(file)"
    )
  .add-file(v-if="status === 'form'")
    FileChooser(v-slot="{ open }" @file-chosen="add_file")
      Button(@click="open")
        FolderIcon
        | 
        | {{ t('upload_add_file') }}
  UploadInfo(v-if="upload_info" :info="upload_info")


  ActiveBox.active-box
    .chooser-box(v-if="status == 'file'")
      .instruction {{ t(instruction) }}
      FileChooser(v-slot="{ open }" @file-chosen="add_file")
        Button(primary @click="open")
          FolderIcon
          | 
          | {{ t('home_btn_choose_file') }}

    .quota(v-if="status == 'quota'")
      | {{ t('upload_quota_exceed', human_quota) }}
      ActionBar
        template(v-slot:left)
          CancelButton(@click="init")

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
import notification from '../notification'
import secrets from '../secrets'
import { human_readable_size } from '../ui-util'
import { is_mobile } from '../util'
import { show_error } from '../error'
import { t } from '../i18n'

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
      type: Array
      default: null

  data: ->
    files: []
    status: 'file'
    upload_info: null
    upload_spec: null
    progress: 0

  computed:
    human_quota: ->
      quota: human_readable_size @upload_spec.quota
      usage: human_readable_size @upload_spec.usage

  mounted: ->
    if @f then @add_file @f

  methods:
    t: t

    init: ->
      @files = []
      @upload_info = null
      @status = 'file'
      @progress = 0

    add_file: (files) ->
      for file in files
        found = false
        for f in @files
          if file.name == f.name
            found = true
            break
        unless found
          @files.push file
      try
        unless @upload_spec
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

    remove_file: (file) ->
      i = @files.indexOf file
      @files.splice i, 1
      if @files.length == 0
        @status = 'file'

    check_quota: ->
      remain = @upload_spec.quota - @upload_spec.usage
      size = 0
      size += file.size for file in @files
      size < remain

    submit: (data) ->
      try
        @upload_info = data
        @upload = Upload.create(
          @files
          @upload_info
          @upload_spec.block_size
          (status, progress) =>
            @status = status
            @progress = progress
        )
        secret = await @upload.upload()
        return unless secret
        notification t('notification_upload'), @files[0].name
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

  computed:
    instruction: -> if is_mobile then 'home_choose' else 'home_drop_or_choose'
</script>

<style scoped lang="stylus">
.add-file
  text-align right
  margin-top 0.8rem
.active-box
  margin 1.6rem 0
.chooser-box
  width 100%
  display flex
  justify-content space-between
  align-items center
  .instruction
    flex-grow 1
.v-move
  transition transform .2s
.v-leave-active
  display none
</style>

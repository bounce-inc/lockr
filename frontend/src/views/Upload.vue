<template lang="pug">
.container
  FileInfo(v-if="files.length == 1" :file="files[0]")
  FileInfo(v-if="files.length > 1" zip :file="zip_info")
  
  FileList(v-if="files.length > 1" :files="files" removable)

  .add-file(v-if="status === 'form'")
    FileChooser(v-slot="{ open }" @file-chosen="add_file")
      Button(@click="open")
        FolderIcon
        | 
        | {{ t('upload_add_file') }}

  UploadInfo.upload-info(v-if="upload_info" :info="upload_info")

  ActiveBox.active-box
    .chooser-box(v-if="status == 'file'")
      .instruction {{ t(instruction) }}
      FileChooser(v-slot="{ open }" @file-chosen="add_file")
        Button(primary @click="open")
          FolderIcon
          | 
          | {{ t('home_btn_choose_file') }}

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
import FileList from '../components/FileList'
import FolderIcon from 'vue-material-design-icons/Folder'
import NotificationRequest from '../components/NotificationRequest'
import ProgressBar from '../components/ProgressBar'
import Spinner from '../components/Spinner'
import Upload from '../upload'
import UploadForm from '../components/UploadForm'
import UploadInfo from '../components/UploadInfo'
import Zip from '../zip'
import api from '../api'
import notification from '../notification'
import metadata from '../metadata'
import { human_readable_size } from '../ui-util'
import { is_mobile } from '../util'
import { AppError, show_error } from '../error'
import { t } from '../i18n'

export default
  components: {
    ActionBar
    ActiveBox
    Button
    CancelButton
    FileChooser
    FileInfo
    FileList
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

    instruction: ->
      if is_mobile then 'upload_choose' else 'upload_drop_or_choose'

    zip_info: ->
      zip = new Zip @files
      len = zip.length()
      name: t 'upload_files', count: @files.length
      size: len

  mounted: -> if @f then @add_file @f

  methods:
    t: t

    init: ->
      @files = []
      @upload_info = null
      @status = 'file'
      @progress = 0

    add_file: (files) ->
      if @files.length + files.length > 100
        show_error new Error 'upload_too_many'
        return

      new_files = @files.slice 0

      for file in files
        found = false
        for f in @files
          if file.name == f.name
            found = true
            break
        unless found
          new_files.push file

      try
        unless @upload_spec
          @status = 'query'
          @upload_spec = await api 'GET', '/uploads/info'
        @check_quota(new_files)
        if new_files.length > 1
          new Zip new_files # check zippable
        @status = 'form'
        @files = new_files
      catch e
        @status = 'file' if @status = 'query'
        show_error e, =>
          @status =
            if @files.length
              'form'
            else
              'file'

    remove_file: (file) ->
      i = @files.indexOf file
      @files.splice i, 1
      if @files.length == 0
        @status = 'file'

    check_quota: (files) ->
      remain = @upload_spec.quota - @upload_spec.usage
      size = 0
      size += file.size for file in files
      if size > remain
        throw new AppError 'quota', @human_quota

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
        metadata.set @upload.id, @upload.meta
        notification t('notification_upload'), @files[0].name
        @$router.push name: 'uploaded_file', params:
          id: @upload.id
          secret: secret
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
.upload-info
  margin 1.6rem 0

@media (max-width 640px)
  .chooser-box
    flex-direction column
    .instruction
      margin-bottom 0.8rem
</style>

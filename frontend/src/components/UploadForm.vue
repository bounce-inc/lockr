<template lang="pug">
form(@submit.prevent="submit")
  .field
    label {{ t('upload_max_dl') }}: 
    Select(v-model.number="count" :options="count_options")
    .tip
      TipIcon
      | {{ t('uploadform_tip_max_dl') }}
  .field
    label {{ t('upload_period') }}: 
    Select(v-model.number="period" :options="period_options")
    .tip
      TipIcon
      | {{ t('uploadform_tip_dl_period') }}
  .field
    label {{ t('app_password') }}: 
    TextBox(
      type="password"
      v-model.trim="password"
      :placeholder="t('app_optional')"
    )
  ActionBar
    template(v-slot:left)
      CancelButton(@click="$emit('cancel')")
    Button(primary)
      UploadIcon
      | 
      | {{ t('uploadform_submit') }}
</template>

<script lang="coffee">
import ActionBar from './ActionBar'
import Button from './Button'
import CancelButton from './CancelButton'
import Select from './Select'
import TextBox from './TextBox'
import TipIcon from 'vue-material-design-icons/Lightbulb'
import UploadIcon from 'vue-material-design-icons/CloudUpload'
import { human_readable_time } from '../ui-util'
import { t } from '../i18n'

KEY = 'lockr_upload_info'

export default
  props:
    uploadLimits:
      type: Object
      required: true
  components: {
    ActionBar
    Button
    CancelButton
    Select
    TextBox
    TipIcon
    UploadIcon
  }
  data: ->
    count: 1
    period: 12 * 60 * 60
    password: ''
  computed:
    count_options: ->
      [ 1, 2, 3, 5, 7, 10, 15, 20, 30, 50, 70, 100 ]
      .filter (c) => c <= @uploadLimits.max_downloads
      .map (c) -> value: c, label: t('app_times', times: c)
    period_options: ->
      MINUTE = 60
      HOUR = 60 * MINUTE
      DAY = 24 * HOUR
      [
        10 * MINUTE
        30 * MINUTE
        HOUR
        3 * HOUR
        6 * HOUR
        12 * HOUR
        DAY
        3 * DAY
        7 * DAY
        14 * DAY
        30 * DAY
      ]
      .filter (s) => s <= @uploadLimits.max_period
      .map (s) -> value: s, label: human_readable_time s

  created: ->
    stored = localStorage[KEY]
    if stored
      data = JSON.parse stored
      @count = data.count
      @period = data.period

  methods:
    t: t
    submit: ->
      localStorage[KEY] = JSON.stringify count: @count, period: @period
      @$emit 'submit',
        count: @count
        period: @period
        password: @password
</script>

<style scoped lang="stylus">
label
  font-weight bold
.field
  margin-bottom 1.6rem
.tip
  font-size 1.4rem
  line-height 2.4rem
  opacity 0.7
</style>

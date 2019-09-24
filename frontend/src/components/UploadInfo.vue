<template lang="pug">
.container
  .item {{ t('upload_max_dl') }}: {{ t('app_times', { times: info.count }) }}
  .item {{ t('upload_period') }}: {{ period }}
</template>

<script lang="coffee">
import { t } from '../i18n'
import { human_readable_time } from '../ui-util'

export default
  props:
    info:
      type: Object
      required: true
  methods: { t }
  computed:
    period: -> human_readable_time @info.period
</script>

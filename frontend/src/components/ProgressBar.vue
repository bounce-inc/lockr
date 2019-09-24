<template lang="pug">
.wrapper
  .bar
    .inner(:style="{ width: progress * 100 + '%' }")
  .estimate
    .span(v-if="estimation") {{ t('app_progress', { time: estimation_human }) }}
    .span(v-else) &nbsp;
</template>

<script lang="coffee">
import { human_readable_time } from '../ui-util'
import { t } from '../i18n'

export default
  props:
    progress:
      type: Number
      required: true
  data: ->
    timer: null
    estimation: null
    start_time: 0
    orig_title: document.title
  computed:
    estimation_human: ->
      human_readable_time @estimation / 1000
    percentile: -> Math.min 100, Math.round(100 * @progress)
  mounted: ->
    @start_time = Date.now()
    @timer = setInterval @estimate, 10 * 1000
  beforeDestroy: ->
    clearInterval @timer
    document.title = @orig_title
  methods:
    t: t
    estimate: ->
      elapsed = Date.now() - @start_time
      total = elapsed / @progress
      left = total - elapsed
      if left < 0
        left = 0
      if isFinite left
        @estimation = left
  watch:
    percentile: (val) ->
      document.title = "(#{val}%) #{@orig_title}"

</script>

<style scoped lang="stylus">
.bar
  height 0.8rem
  border 0.1rem solid #eee
  border-radius 0.4rem
  overflow hidden
  margin 0.4rem
  .inner
    background #eee
    height 100%
.estimate
  text-align right
  opacity 0.7
  font-size 1.4rem
  line-height 1.6rem
</style>

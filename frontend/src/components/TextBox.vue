<template lang="pug">
input.input(
  :type="type"
  :placeholder="placeholder"
  :value="value"
  @input="$emit('input', $event.target.value)"
  @change="$emit('change', $event.target.value)"
)
</template>

<script lang="coffee">
export default
  props:
    type:
      type: String
      default: 'text'
    placeholder:
      type: String
      default: ''
    value:
      type: String
      default: ''
    autofocus:
      type: Boolean
      default: false

  mounted: ->
    if @autofocus
      @$el.focus()
</script>

<style scoped lang="stylus">
.input
  padding 0.4rem 0.8rem
  border 0.1rem solid #666
  background #333
  border-radius 0.4rem
</style>

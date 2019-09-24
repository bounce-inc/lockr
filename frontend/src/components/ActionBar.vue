<template lang="pug">
.bar
  slot(name="left")
  .space
  slot
</template>

<style scoped lang="stylus">
.bar
  margin-top 1.6rem
  display flex
  .space
    flex-grow 1
</style>

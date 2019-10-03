<template lang="pug">
.container
  h2 Backend
  table(v-if="backend_info")
    tr
      th get_rand
      td {{ web_or_asm(backend_info.get_rand) }}
    tr
      th hmac
      td {{ web_or_asm(backend_info.hmac) }}
    tr
      th stretch
      td {{ web_or_asm(backend_info.stretch) }}
    tr
      th encrypt/decrypt
      td {{ web_or_asm(backend_info.encrypt) }}

  h2 Test Result
  Spinner(v-if="testing")
  p(v-if="ok") OK
  p(v-if="ng") Failure

  h2(v-if="stretch_result.length") Stretch Benchmark
  table
    tr(v-for="[i, t] in stretch_result" :key="i")
      th 2^{{ i }}
      td {{ t }} ms
  Button(@click="test" v-if="finish") Test Again

</template>

<script lang="coffee">
import Button from '../components/Button'
import Spinner from '../components/Spinner'
import i18n from '../i18n'
import test from '../test'
import Crypto from '../crypto'
import { backend_info } from '../crypto-backend'

export default
  components: { Button, Spinner }

  data: ->
    t: i18n.t.bind i18n
    testing: false
    ok: false
    ng: false
    finish: false
    stretch_result: []
    backend_info: null

  created: ->
    @test()

  methods:
    test: ->
      crypto = new Crypto
      await crypto.init()
      @backend_info = await backend_info()

      @ok = @ng = @finish = false
      @testing = true
      @stretch_result = []

      try
        @ok = await test()
      catch e
        @ng = true
        throw e
      finally
        @testing = false

      for i in [10...32]
        t = Date.now()
        n = 1 << i
        await crypto.stretch 'test1234', n
        t = Date.now() - t
        @stretch_result.push [i, t]
        if t >= 1000
          break
      @finish = true

    web_or_asm: (is_web) -> if is_web then 'Web Crypto' else 'asmCrypto'
</script>

<style scoped lang="stylus">
h2
  margin-top .8rem
th
  text-align left
td
  padding-left .8rem
</style>

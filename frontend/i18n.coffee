fs = require 'fs'

translations = [
  lang: 'en'
  copy: 'Secure File Transfer Made Simple'
  description: '''
    "Secure file transfer service with end-to-end encryption (E2EE)
    and double 256-bit encryption.
    You no longer need to encrypt your file before sending it.
    Free up to 50GB.
    Also features automatic expiration, download count limit,
    and password protection."'''
  noscript: '''We're sorry but Lockr doesn't work properly without
    JavaScript enabled. Please enable it to continue.'''
,
  lang: 'ja',
  copy: 'セキュアなファイル転送をシンプルに'
  description:
    '"エンドtoエンド暗号化(E2EE)と二重の256ビット暗号化を採用した' +
    'ファイル転送サービスです。' +
    'パスワード付きZIPファイルの代替に最適です。' +
    '50GBまで無料でお使いいただけます。' +
    '期限による自動消去、ダウンロード回数制限、パスワード保護も備えています。"'
  noscript: 'LockrはJavaScriptが有効でないと動作しません。' +
    'JavaScriptを有効にしてから再読み込みしてください。'
]

dir = process.argv[2] or "#{__dirname}/dist"
src = fs.readFileSync "#{dir}/index.html", 'utf8'
first = true
for t in translations
  dist = src.replace /#{(\w+)}/g, (_, key) ->
    t[key].replace /\n/g, ' '
  fs.mkdirSync "#{dir}/#{t.lang}"
  fs.writeFileSync "#{dir}/#{t.lang}/index.html", dist
  if first
    fs.writeFileSync "#{dir}/index.html", dist
    first = false

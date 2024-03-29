パスワード付きZIPファイル (PPAP) の代替に最適です。

## エンドツーエンド暗号化 (E2E暗号化、E2EE)

従来のファイル転送サービスの多くには、ファイルが暗号化されずに扱われるポイントが存在するため、運営者内部やハッキングによって情報が漏洩するリスクがありました。

Lockr は、ファイルを送信者のブラウザで256ビット暗号化してからサーバーに送信し、受信者のブラウザで復号化します。暗号鍵は送信者のブラウザで生成され、決してサーバーに送信されることがないので、私たち運営者でさえファイルの中身を知ることはできません。

> ファイルの内容だけでなく、ファイル名などのメタデータも暗号化の対象です。私たちに知ることができるのは、大まかなファイルサイズだけです。

## 二重の暗号化

クライアント側で暗号化されたデータは、更にサーバー側でも256ビット暗号化されます。暗号鍵はアップロードごとに生成され、ファイル削除時に破棄されます。このため、一度ファイルが削除されると、たとえ削除ファイルを復元できたとしても、元のデータを取り出すことはできません。

## 無料で50GB

テレワーク支援のため、期間限定でユーザーあたり50GBまで無償提供しています。

## 幅広いブラウザ サポート

すべてのモダンブラウザに加えて、 Internet Explorer 11 をサポートしています。

> 一部のブラウザでは非常に大きなファイルをダウンロードできないことがあります。

## 自動削除

アップロード時に、ファイルの有効期限と最大ダウンロード回数を設定できます。有効期限が切れるか、最大ダウンロード回数に達すると、ファイルは自動的に消去されます。

## パスワード保護

アップロード時にパスワードを設定することができます。

ダウンロードURLは暗号学的に予測不可能なため、URLが第三者に知られる可能性がなければ、パスワードを設定する必要はありません。

URLを十分に安全でない方法で送信する場合、パスワードを設定して別の方法で共有することにより、セキュリティを保つことができます。URLとパスワードを同じ経路で送信しても意味はありません。

パスワードを別送する方法として、弊社の <a href="https://one-time.link/" target="_blank" rel="noopener">One Time Link</a> をおすすめします。

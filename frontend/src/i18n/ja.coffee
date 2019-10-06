export default
  app_catch: 'セキュアなファイル転送をシンプルに'
  app_old_browser_warn: 'このブラウザはLockrの動作に必要な機能を' +
    '満たしていません。より新しいブラウザをお使いください。'
  app_maintenance: 'ただいまサービスのメンテナンス中です。' +
    '時間をおいてからお試しください。' +
    'ご不便をおかけいたします。'
  app_btn_close: '閉じる'
  app_times: '#{times}回'
  app_days: '#{days}日'
  app_hours: '#{hours}時間'
  app_minutes: '#{minutes}分'
  app_seconds: '#{seconds}秒'
  app_few_seconds: '数秒'
  app_optional: '(省略可)'
  app_password: 'パスワード'
  app_progress: '残り#{time}'
  app_cancel: 'キャンセル'
  app_delete: '削除'
  app_deleted_downloads:
    'このファイルは最大ダウンロード数に達したため削除されました。'
  app_deleted_expired:
    'このファイルは有効期限を過ぎたため削除されました。'
  app_deleted_user: 'このファイルはユーザーにより削除されました。'
  app_deleted_banned: 'このファイルは削除されました。'
  app_share: 'シェア'
  app_copyright: 'BOUNCE株式会社'
  app_terms_of_use: '利用規約'
  app_privacy_policy: 'プライバシーポリシー'

  cookie_notice: 'このサイトはCookieを使用しています。<br>' +
    'このサイトを使用することにより、あなたは' +
    '<a href="/privacy" target="_blank">プライバシーポリシー</a>と' +
    '<a href="/terms" target="_blank">利用規約</a>に同意したことになります。'

  home_drop_or_choose: 'ファイルの送信はとても簡単です。<br>' +
    'ファイルを選択するかここにドロップしてください。'
  home_choose:
    'ファイルの送信はとても簡単です。<br>送信するファイルを選択してください。'
  home_btn_choose_file: 'ファイルを選択'

  file_chooser_drop_it: 'ドロップしてアップロード'
  file_chooser_drop_them: 'ドロップしてアップロード'

  util_bytes: '#{size}バイト'

  test_start: 'テスト開始'
  test_testing: 'テスト中...'
  test_ok: 'OK'
  test_ng: 'エラー'

  fileinfo_filename: 'ファイル名'
  fileinfo_size: 'サイズ'
  fileinfo_last_modified: '最終更新'

  upload_drop_or_choose:
    '送信するファイルを選択するかここにドロップしてください。'
  upload_choose: '送信するファイルを選択してください。'
  upload_add_file: 'ファイルを追加'
  upload_uploading: '暗号化してアップロードしています...'
  upload_max_dl: '最大ダウンロード回数'
  upload_period: '有効期限'
  upload_files: '#{count} ファイル'

  uploadform_tip_max_dl:
    'セキュリティのため、可能な限り少ない回数を指定してください。'
  uploadform_tip_dl_period:
    'セキュリティのため、可能な限り短い期間を指定してください。'
  uploadform_submit: 'アップロード'

  uploadedfile_completed: '暗号化アップロードは正常に完了しました。'
  uploadedfile_label_link: 'ダウンロードURL'
  uploadedfile_copy: 'クリップボードにコピー'
  uploadedfile_copied: 'コピーしました'
  uploadedfile_noinfo_title: '詳細不明'
  uploadedfile_noinfo_desc: 'このブラウザにはこのアップロードに対応する' +
    '暗号鍵がないため、詳細を表示できません。'
  uploadedfile_remaining_time: '残り時間'
  uploadedfile_dl_max: '最大ダウンロード'
  uploadedfile_dl_success: 'ダウンロード完了'
  uploadedfile_dl_failure: 'ダウンロード失敗'
  uploadedfile_dl_progress: 'ダウンロード中'
  uploadedfile_confirm_delete: 'ファイルをサーバーから削除してよろしいですか?'
  uploadedfile_more: '他のファイルをアップロードする'

  filelist_more: '他#{count}ファイル'
  filelist_less: '少なく表示'

  download_password: 'パスワード'
  download_btn_download: 'ダウンロード'
  download_wrong_password: 'パスワードが違います'
  download_downloading: 'ダウンロードして復号化しています...'
  download_completed: 'ダウンロードが完了しました。'
  download_canceled: 'キャンセルしました。'
  download_learn: 'Lockrについて詳しく知る'
  download_conflict:
    'このファイルをダウンロード中のユーザ数が最大数に達しました。'
  download_large_file_warn: 'お使いのブラウザはこのサイズのファイルを' +
    'ダウンロードできない可能性があります。もしダウンロードが止まったり' +
    'デバイスの動作が遅くなった場合は、別のブラウザでダウンロードして' +
    'ください。'
  download_win_warn: 'ファイル名が文字化けする場合は ' +
    '<a href="https://forest.watch.impress.co.jp/library/software/7zip/"' +
    ' target="_blank" rel="noopener">7-Zip</a> ' +
    '等をお使いください。'

  notification_description:
    '転送完了時にデスクトップ通知を受け取ることができます。'
  notification_btn_enable: '通知を有効にする'
  notification_upload: 'アップロードが完了しました'
  notification_download: 'ダウンロードが完了しました'

  login_email: 'ユーザーIDまたはメールアドレス'
  login_btn: 'ログイン'

  error_server: 'サーバーエラー'
  error_connection_title: '接続エラー'
  error_connection_detail: 'サーバーに接続できませんでした。'
  error_notfound_title: 'ページがありません'
  error_notfound_detail: 'リクエストされたURLは存在しません。'
  error_signature_title: 'シグネチャーが一致しません'
  error_signature_detail:
    'ファイルが転送中に書き換えられたか、破損した可能性があります。'
  error_websocket_title: 'WebSocketエラー'
  error_websocket_detail: 'WebSocketの接続にエラーが発生しました。'
  error_fileread_title: 'ファイルが読めません'
  error_zip_file_too_large_title: 'ファイルがZIPにできません'
  error_zip_file_too_large_detail: '4GB以上のファイルはZIPに含めることが' +
    'できません。単独で送信してください。'
  error_upload_too_many_title: 'ファイルが多すぎます'
  error_upload_too_many_detail:
      '一度にアップロードできるのは100ファイルまでです。'
  error_login_title: 'ログインできません'
  error_login_detail: 'ユーザIDまたはパスワードが違います。'
  error_quota_title: '容量オーバー'
  error_quota_detail:
    'このサイズのファイルをアップロードすることはできません。' +
    'あなたは#{quota}の容量中#{usage}を使用中です。'

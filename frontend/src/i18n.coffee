KEY = 'lockr_lang'

translations =
  en:
    app_catch: 'Secure File Transfer Made Simple'
    app_old_browser_warn: '''
      This browser does not meet the functionality required to run Lockr.
      Use a newer browser.'''
    app_maintenance: '''
      The service is under maintenance.
      Please try again later.
      We apologize for the inconvenience.'''
    app_btn_close: 'Close'
    app_times: '#{times|time|times}'
    app_days: '#{days|day|days}'
    app_hours: '#{hours|hour|hours}'
    app_minutes: '#{minutes|minute|minutes}'
    app_seconds: '#{seconds|second|seconds}'
    app_few_seconds: 'Seconds'
    app_optional: '(Optional)'
    app_password: 'Password'
    app_progress: '#{time} remaining'
    app_cancel: 'Cancel'
    app_delete: 'Delete'
    app_deleted_downloads: '''
      This file has been deleted because it reached the maximum number of
      downloads.'''
    app_deleted_expired: 'This file has been deleted due to expiration.'
    app_deleted_user: 'This file is deleted by the user.'
    app_deleted_banned: 'This file is deleted.'
    app_share: 'Share'
    app_copyright: 'Bounce Inc.'
    app_terms_of_use: 'Terms of Use'
    app_privacy_policy: 'Privacy Policy'

    cookie_notice: '''
      This website uses Cookies. For details, read our
      <a href="/privacy" target="_blank">Privacy Policy</a>.'''

    home_drop_or_choose: 'Drop here or choose a file to start uploading.'
    home_choose: 'Choose a file to start uploading.'
    home_btn_choose_file: 'Choose File'

    file_chooser_drop_it: 'Drop it to upload'

    util_bytes: 'Bytes'

    test_start: 'Start Testing'
    test_testing: 'Testing...'
    test_ok: 'OK'
    test_ng: 'Error'

    fileinfo_filename: 'Filename'
    fileinfo_size: 'Size'
    fileinfo_last_modified: 'Last Modified'

    upload_uploading: 'Encrypting and uploading...'
    upload_max_dl: 'Maximum downloads'
    upload_period: 'Available for'
    upload_quota_exceed: '''
      You are already using #{usage} out of your quota #{quota}.
      You can't upload a file of this size.'''

    uploadform_tip_max_dl:
      'For security, select the smallest possible number.'
    uploadform_tip_dl_period:
      'For security, select the shortest possible period.'
    uploadform_submit: 'Upload'

    uploadedfile_completed:
      'Your file has been successfully encrypted and uploaded.'
    uploadedfile_label_link: 'Download link'
    uploadedfile_copy: 'Copy to Clipboard'
    uploadedfile_copied: 'Copied!'
    uploadedfile_noinfo_title: 'Details Unknown'
    uploadedfile_noinfo_desc: '''
      This browser cannot display file details because it has no decryption
      key for this upload.'''
    uploadedfile_remaining_time: 'Remaining time'
    uploadedfile_dl_max: 'Maximum downloads'
    uploadedfile_dl_success: 'Successful downloads'
    uploadedfile_dl_failure: 'Failed downloads'
    uploadedfile_dl_progress: 'Downloads in progress'
    uploadedfile_confirm_delete:
      'Are you sure to delete this file from the server?'
    uploadedfile_more: 'Upload another file'

    download_password: 'Password'
    download_wrong_password: 'Wrong password.'
    download_btn_download: 'Download'
    download_downloading: 'Downloading and decrypting...'
    download_completed: 'Download completed.'
    download_canceled: 'Download canceled.'
    download_learn: 'Learn more about Lockr'
    download_conflict:
      'The maximum number of users downloading this file has been reached.'
    download_large_file_warn: '''
      Your browser may not be able to download files of this size.
      If the download stops or the device slows down, download it with
      another browser. '''

    notification_description:
      'You can receive a desktop notification when the transfer completes.'
    notification_btn_enable: 'Enable Notification'
    notification_upload: 'Upload completed!'
    notification_download: 'Download completed!'

    error_server: 'Server error'
    error_connection_title: 'Connection error'
    error_connection_detail: 'Failed to connect to the server.'
    error_notfound_title: 'Not Found'
    error_notfound_detail: 'The requested URL does not exist.'
    error_signature_title: 'Signature does not match'
    error_signature_detail:
      'The file may have been modified or corrupted during transfer.'
    error_websocket_title: 'WebSocket error'
    error_websocket_detail: 'WebSocket connection error.'
    error_fileread_title: 'File is not readable'

  ja:
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

    cookie_notice: 'このサイトはCookieを使用しています。詳しくは' +
      '<a href="/privacy" target="_blank">プライバシーポリシー</a>' +
      'をご覧ください。'

    home_drop_or_choose:
      'ファイルを選択するかドラッグ&ドロップしてアップロードを開始します。'
    home_choose: 'ファイルを選択してアップロードを開始します。'
    home_btn_choose_file: 'ファイルを選択'

    file_chooser_drop_it: 'ドロップしてアップロード'

    util_bytes: 'バイト'

    test_start: 'テスト開始'
    test_testing: 'テスト中...'
    test_ok: 'OK'
    test_ng: 'エラー'

    fileinfo_filename: 'ファイル名'
    fileinfo_size: 'サイズ'
    fileinfo_last_modified: '最終更新'

    upload_uploading: '暗号化してアップロードしています...'
    upload_max_dl: '最大ダウンロード回数'
    upload_period: '有効期限'
    upload_quota_exceed: 'あなたは#{quota}の割り当て中すでに#{usage}を' +
      '使用しています。このサイズのファイルをアップロードすることはできません。'

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

    notification_description:
      '転送完了時にデスクトップ通知を受け取ることができます。'
    notification_btn_enable: '通知を有効にする'
    notification_upload: 'アップロードが完了しました'
    notification_download: 'ダウンロードが完了しました'

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

export default i18n =
  lang: 'en'

  t: (key, args={}) ->
    text = translations[@lang][key] or translations.en[key]
    return null unless text
    for key, val of args
      re = new RegExp '\\#\\{' + key + '(\\|(.+?)\\|(.+?))?\\}', 'g'
      text = text.replace re, (_, noun, singular, plural) ->
        if noun
          if val > 1
            "#{val} #{plural}"
          else
            "#{val} #{singular}"
        else
          val
    text

  set_lang: (lang) ->
    localStorage[KEY] = @lang = lang
    document.title = "Lockr: #{@t 'app_catch'}"
    document.documentElement.lang = lang

lang_from_url = ->
  match = /^\/(en|ja)\/$/.exec location.pathname
  if match
    match[1]
  else
    null

lang = lang_from_url() or localStorage[KEY] or navigator.language.split('-')[0]
unless translations[lang]
  lang = 'en'
i18n.set_lang lang

export t = i18n.t.bind i18n

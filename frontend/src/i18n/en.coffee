export default
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
  app_deleted_user: 'This file has been deleted by the user.'
  app_deleted_banned: 'This file has been deleted.'
  app_share: 'Share'
  app_copyright: 'Bounce Inc.'
  app_terms_of_use: 'Terms of Use'
  app_privacy_policy: 'Privacy Policy'

  cookie_notice: '''
    This website uses Cookies.<br>By using this website, you are agreeing to our
    <a href="/privacy" target="_blank">Privacy Policy</a> and
    <a href="/terms" target="_blank">Terms of Use</a>.'''

  home_drop_or_choose:
    'Sending files is so easy.<br>Just drop here or choose files.<br>'
  home_choose: 'Sending files is so easy.<br>Just choose files.'
  home_btn_choose_file: 'Choose Files'

  file_chooser_drop_it: 'Drop it to upload'
  file_chooser_drop_them: 'Drop them to upload'

  util_bytes: '#{size|byte|bytes}'

  test_start: 'Start Testing'
  test_testing: 'Testing...'
  test_ok: 'OK'
  test_ng: 'Error'

  fileinfo_filename: 'Filename'
  fileinfo_size: 'Size'
  fileinfo_last_modified: 'Last Modified'

  upload_drop_or_choose:
    'Drop here or choose files to upload.'
  upload_choose: 'Choose files to upload.'
  upload_add_file: 'Add Files'
  upload_uploading: 'Encrypting and uploading...'
  upload_max_dl: 'Maximum downloads'
  upload_period: 'Available for'
  upload_files: '#{count|File|Files}'

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
  uploadedfile_noinfo_desc:
    'This browser does not have file details of this upload.'
  uploadedfile_remaining_time: 'Remaining time'
  uploadedfile_dl_max: 'Maximum downloads'
  uploadedfile_dl_success: 'Successful downloads'
  uploadedfile_dl_failure: 'Failed downloads'
  uploadedfile_dl_progress: 'Downloads in progress'
  uploadedfile_confirm_delete:
    'Are you sure to delete this file from the server?'
  uploadedfile_more: 'Upload another file'
  uploadedfile_link_notice: '''This is your last chance to see this link.
    Be sure to copy it before leaving this page.'''

  filelist_more: '#{count|more file|more files}'
  filelist_less: 'Show less'

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
  download_win_warn: '''If some of the file names are garbled, use
    <a href="https://www.7-zip.org/" target="_blank" rel="noopener">7-Zip</a>
    or other unarchivers.'''
  download_qr: 'Show QR code'
  download_expiry: 'Expires after #{count|download|downloads} or #{time}.'

  notification_description:
    'You can receive a desktop notification when the transfer completes.'
  notification_btn_enable: 'Enable Notification'
  notification_upload: 'Upload completed!'
  notification_download: 'Download completed!'

  login_email: 'Username or email address'
  login_btn: 'Login'

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
  error_wsclose_title: 'Network error'
  error_wsclose_detail: 'Connection closed.'
  error_dir_read_title: 'Your browser is incapable to upload folders'
  error_fileread_title: 'File is not readable'
  error_zip_file_too_large_title: 'File is too large to zip'
  error_zip_file_too_large_detail: '''Files over 4GB cannnot be included in a
    ZIP file. Send it separately.'''
  error_upload_too_many_title: 'Too many files'
  error_upload_too_many_detail: 'You can upload up to 100 files at once.'
  error_login_title: 'Login failed'
  error_login_detail: 'Wrong username (email) or password.'
  error_quota_title: 'Quota exceeded'
  error_quota_detail: '''You can't upload files of this size.
    You are using #{usage} out of your quota #{quota}. '''

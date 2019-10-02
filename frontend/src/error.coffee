import { t } from './i18n'

export error_status =
  title: ''
  detail: ''
  onclose: null
  maintenance: false
  clear: ->
    @title = @detail = ''
    @onclse = null

export show_error = (e, onclose) ->
  if e.message == 'maintenance'
    error_status.maintenance = true
    return

  title = t("error_#{e.message}_title")
  detail = ''

  if title
    detail = t("error_#{e.message}_detail")
  else if e.status
    title = "#{t 'error_server'} #{e.status}"
    detail = e.message
  else
    title = e.message

  error_status.title = title
  error_status.detail = detail
  error_status.onclose = onclose

  try
    document.activeElement.blur()
  catch

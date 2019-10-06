import { t } from './i18n'

export error_status =
  title: ''
  detail: ''
  onclose: null
  maintenance: false
  clear: ->
    @title = @detail = ''
    @onclose = null

export class AppError extends Error
  constructor: (message, @params) ->
    super message

export show_error = (e, onclose) ->
  if e.message == 'maintenance'
    error_status.maintenance = true
    return

  title = t("error_#{e.message}_title")
  detail = ''

  if title
    detail = t("error_#{e.message}_detail", e.params or {})
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

import { DOWNLOAD_FILE_CONFIG } from '@/config/download'

export function getDownloadUrl(key) {
  const item = DOWNLOAD_FILE_CONFIG.files[key]
  if (!item) return ''
  if (/^https?:\/\//.test(item.url)) return item.url
  const base = DOWNLOAD_FILE_CONFIG.baseUrl.replace(/\/$/, '')
  const url = item.url.replace(/^\//, '')
  return `${base}/${url}`
}

export function downloadConfiguredFile(key) {
  const url = getDownloadUrl(key)
  if (!url) return
  const item = DOWNLOAD_FILE_CONFIG.files[key]
  const link = document.createElement('a')
  link.href = url
  link.download = item.filename || ''
  link.target = '_blank'
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

import { VERIFY_CODE_CONFIG } from '@/config/verify'

export function getVerifyImageUrl(key) {
  const item = VERIFY_CODE_CONFIG.codes[key]
  if (!item) return ''
  if (/^https?:\/\//.test(item.url)) return item.url
  const base = VERIFY_CODE_CONFIG.baseUrl.replace(/\/$/, '')
  const url = item.url.replace(/^\//, '')
  return `${base}/${url}`
}

export function pickRandomVerifyCode(excludeKey) {
  const keys = Object.keys(VERIFY_CODE_CONFIG.codes)
  const candidates = excludeKey ? keys.filter(key => key !== excludeKey) : keys
  const pool = candidates.length ? candidates : keys
  const key = pool[Math.floor(Math.random() * pool.length)]
  const item = VERIFY_CODE_CONFIG.codes[key]
  return {
    key,
    value: item.value,
    imageUrl: getVerifyImageUrl(key)
  }
}

export function rpaAttr(prefix, value) {
  return `${prefix}-${String(value || '').replace(/[^a-zA-Z0-9_-]/g, '-')}`
}

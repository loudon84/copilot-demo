const API = {
  async request(url, options = {}) {
    const res = await fetch(url, { headers: { 'Content-Type':'application/json', ...(options.headers || {}) }, ...options });
    const data = await res.json();
    if (!res.ok || data.code !== 0) throw new Error(data.message || '请求失败');
    return data.data;
  },
  listProducts(){ return this.request('/api/products'); },
  getProduct(id){ return this.request('/api/products/' + encodeURIComponent(id)); },
  createProduct(payload){ return this.request('/api/products', { method:'POST', body:JSON.stringify(payload) }); },
  updateProduct(id,payload){ return this.request('/api/products/' + encodeURIComponent(id), { method:'PUT', body:JSON.stringify(payload) }); },
  deleteProduct(id){ return this.request('/api/products/' + encodeURIComponent(id), { method:'DELETE' }); },
  listSuppliers(){ return this.request('/api/suppliers'); }
};
function money(n){ const v=Number(n||0); return v.toLocaleString('zh-CN',{minimumFractionDigits:2,maximumFractionDigits:2}); }
function getQuery(name){ return new URLSearchParams(location.search).get(name); }
function esc(str){ return String(str ?? '').replace(/[&<>"']/g, s => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[s])); }
function appendBridgeLog(id, data){ const el=document.getElementById(id); if(!el) return; const text = typeof data === 'string' ? data : JSON.stringify(data,null,2); el.textContent = `[${new Date().toLocaleTimeString()}] ${text}\n` + el.textContent; }
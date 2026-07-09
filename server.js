const http = require('http');
const fs = require('fs');
const path = require('path');
const { URL } = require('url');

const ROOT = __dirname;
const PUBLIC_DIR = path.join(ROOT, 'public');
const DATA_DIR = path.join(ROOT, 'data');
const PRODUCTS_FILE = path.join(DATA_DIR, 'products.json');
const SUPPLIERS_FILE = path.join(DATA_DIR, 'suppliers.json');
const PORT = Number(process.env.PORT || 3000);

function ensureDataFiles(){
  if(!fs.existsSync(DATA_DIR)) fs.mkdirSync(DATA_DIR,{recursive:true});
  if(!fs.existsSync(PRODUCTS_FILE)) fs.writeFileSync(PRODUCTS_FILE,'[]\n','utf8');
  if(!fs.existsSync(SUPPLIERS_FILE)) fs.writeFileSync(SUPPLIERS_FILE,'[]\n','utf8');
}
function readJson(file){ ensureDataFiles(); return JSON.parse(fs.readFileSync(file,'utf8') || '[]'); }
function writeJson(file, data){ ensureDataFiles(); fs.writeFileSync(file, JSON.stringify(data,null,2),'utf8'); }
function sendJson(res,status,data){ const body=JSON.stringify(data); res.writeHead(status,{'Content-Type':'application/json; charset=utf-8','Content-Length':Buffer.byteLength(body)}); res.end(body); }
function sendText(res,status,text,contentType='text/plain; charset=utf-8'){ res.writeHead(status,{'Content-Type':contentType}); res.end(text); }
function readBody(req){ return new Promise((resolve,reject)=>{ let body=''; req.on('data',chunk=>{ body += chunk; if(body.length > 2*1024*1024){ reject(new Error('BODY_TOO_LARGE')); req.destroy(); }}); req.on('end',()=>{ try{ resolve(body ? JSON.parse(body) : {}); }catch(err){ reject(new Error('INVALID_JSON')); }}); req.on('error',reject); }); }
function contentTypeByExt(filePath){ const ext=path.extname(filePath).toLowerCase(); return {'.html':'text/html; charset=utf-8','.js':'application/javascript; charset=utf-8','.css':'text/css; charset=utf-8','.json':'application/json; charset=utf-8','.ico':'image/x-icon'}[ext] || 'application/octet-stream'; }
function serveStatic(req,res,pathname){ let target=pathname === '/' ? '/product-list.html' : pathname; const filePath=path.normalize(path.join(PUBLIC_DIR,target)); if(!filePath.startsWith(PUBLIC_DIR)){ return sendText(res,403,'Forbidden'); } if(!fs.existsSync(filePath) || !fs.statSync(filePath).isFile()){ return sendText(res,404,'Not found'); } res.writeHead(200,{'Content-Type':contentTypeByExt(filePath)}); fs.createReadStream(filePath).pipe(res); }
function normalizeProduct(input, existingId){ const now = new Date().toISOString(); return {
  id: existingId || input.id || `P-${Date.now()}`,
  sku: String(input.sku || '').trim(), brand: String(input.brand || '').trim(), model: String(input.model || '').trim(), productName: String(input.productName || '').trim(),
  series: String(input.series || '').trim(), os: String(input.os || '').trim(), chipset: String(input.chipset || '').trim(), screenSize: String(input.screenSize || '').trim(),
  ram: String(input.ram || '').trim(), storage: String(input.storage || '').trim(), color: String(input.color || '').trim(), batteryMah: Number(input.batteryMah || 0),
  network: String(input.network || '').trim(), retailPrice: Number(input.retailPrice || 0), status: String(input.status || 'draft'), launchDate: String(input.launchDate || '').trim(),
  description: String(input.description || '').trim(), suppliers: Array.isArray(input.suppliers) ? input.suppliers.map(row=>({
    supplierId: String(row.supplierId || '').trim(), supplierName: String(row.supplierName || '').trim(), supplyPrice: Number(row.supplyPrice || 0), stockQty: Number(row.stockQty || 0),
    moq: Number(row.moq || 1), leadTimeDays: Number(row.leadTimeDays || 0), status: String(row.status || 'available'), remark: String(row.remark || '')
  })).filter(row=>row.supplierId) : [], createdAt: input.createdAt || now, updatedAt: now
}; }
async function handleApi(req,res,urlObj){ const pathname=urlObj.pathname;
  if(req.method==='GET' && pathname==='/api/products'){ const products=readJson(PRODUCTS_FILE); return sendJson(res,200,{code:0,data:products,count:products.length}); }
  if(req.method==='GET' && pathname.startsWith('/api/products/')){ const id=decodeURIComponent(pathname.split('/').pop()); const product=readJson(PRODUCTS_FILE).find(x=>x.id===id); if(!product) return sendJson(res,404,{code:404,message:'PRODUCT_NOT_FOUND'}); return sendJson(res,200,{code:0,data:product}); }
  if(req.method==='POST' && pathname==='/api/products'){ const input=await readBody(req); const products=readJson(PRODUCTS_FILE); const product=normalizeProduct(input); products.unshift(product); writeJson(PRODUCTS_FILE,products); return sendJson(res,200,{code:0,data:product}); }
  if(req.method==='PUT' && pathname.startsWith('/api/products/')){ const id=decodeURIComponent(pathname.split('/').pop()); const input=await readBody(req); const products=readJson(PRODUCTS_FILE); const idx=products.findIndex(x=>x.id===id); if(idx<0) return sendJson(res,404,{code:404,message:'PRODUCT_NOT_FOUND'}); const product=normalizeProduct({...input, createdAt: products[idx].createdAt}, id); products[idx]=product; writeJson(PRODUCTS_FILE,products); return sendJson(res,200,{code:0,data:product}); }
  if(req.method==='DELETE' && pathname.startsWith('/api/products/')){ const id=decodeURIComponent(pathname.split('/').pop()); const next=readJson(PRODUCTS_FILE).filter(x=>x.id!==id); writeJson(PRODUCTS_FILE,next); return sendJson(res,200,{code:0,data:{id}}); }
  if(req.method==='GET' && pathname==='/api/suppliers'){ const suppliers=readJson(SUPPLIERS_FILE); return sendJson(res,200,{code:0,data:suppliers,count:suppliers.length}); }
  return sendJson(res,404,{code:404,message:'API_NOT_FOUND'});
}
ensureDataFiles();
http.createServer(async (req,res)=>{ try{ const urlObj=new URL(req.url,`http://${req.headers.host}`); if(urlObj.pathname.startsWith('/api/')) return await handleApi(req,res,urlObj); serveStatic(req,res,urlObj.pathname); }catch(err){ sendJson(res,500,{code:500,message:err.message || 'SERVER_ERROR'}); }}).listen(PORT,()=>console.log(`CRM Lite Layui Electron Demo running at http://localhost:${PORT}`));
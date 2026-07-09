# CRM Lite Layui Electron Demo

用于验证 CRM Web 页面与 Electron WebContentsView / Preload / CRM JSSDK 的双向交互。

## 启动

```bash
node server.js
```

访问：

```text
http://localhost:5178
```

## 页面

- `/product-list.html`：商品列表
- `/product-form.html`：商品新增 / 编辑表单
- `/product-view.html?id=产品ID`：商品查看表单，包含「同步到 Electron」按钮
- `/suppliers.html`：供应商列表，商品表单中选择供应商子表使用

## 新增验证功能

### 1. 商品查看页 → Electron

商品查看页点击「同步到 Electron」后：

```text
页面点击按钮
→ crm-desktop-jssdk 收集商品主表 + 供应商子表
→ window.CopilotDesktopCRM.emit(event)
→ Electron Preload 接收
→ Main Process 处理
```

如果没有 Electron Preload，SDK 会使用 `window.postMessage` fallback，页面日志会显示 fallback 结果。

### 2. Electron → 商品新增页

商品新增页监听 Electron command：

- `desktop.crm.product.fillForm`：把 Electron 下发的商品填充到表单
- `desktop.crm.product.create`：把 Electron 下发的商品直接写入 `data/products.json`

页面提供两个测试按钮：

- 模拟 Electron 填充
- 模拟 Electron 写入 JSON

## Electron 下发 command 示例

```js
window.postMessage({
  source: 'copilot-desktop',
  channel: 'crm.desktop.command',
  command: {
    commandId: 'cmd_001',
    type: 'desktop.crm.product.create',
    payload: {
      product: {
        sku: 'PHONE-ELECTRON-001',
        brand: 'Electron Mobile',
        model: 'Bridge X1',
        productName: 'Electron Bridge X1 512GB',
        ram: '12GB',
        storage: '512GB',
        retailPrice: 5999,
        suppliers: []
      }
    },
    createdAt: new Date().toISOString()
  }
}, location.origin);
```

## 数据文件

- `data/products.json`
- `data/suppliers.json`
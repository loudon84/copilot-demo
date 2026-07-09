# CRM Lite JSSDK 集成手册

本文档说明如何在任意 Web 页面中接入 `crm-lite-jssdk.js`，与 **copilot-desktop WebOperator** 进行双向通信。

本 Demo 参考实现见：

- SDK：`public/assets/crm-lite-jssdk.js`
- 上报上下文：`public/product-view.html`
- 接收命令：`public/product-form.html`

---

## 1. 架构概览

```
┌──────────────────── 你的 CRM 网页 ────────────────────┐
│  crm-lite-jssdk.js  →  window.CopilotCrmDesktopSDK   │
└───────────────┬──────────────────────▲────────────────┘
                │ emit / postMessage   │ postMessage command
                ▼                      │
┌────────── copilot-desktop Preload ───┴────────────────┐
│  window.CopilotDesktopCRM  (crm-bridge-preload.js)    │
└───────────────┬───────────────────────────────────────┘
                │ IPC
                ▼
┌────────── Main Process CRM Bridge ──────────────────┐
│  事件存储 / 路由 → CrmEventPanel（侧栏调试面板）      │
└─────────────────────────────────────────────────────┘
```

**两条数据流：**

| 方向 | 典型场景 | SDK 入口 |
|------|----------|----------|
| 网页 → Desktop | 用户点击「同步到 Electron」，把当前商品上下文交给 AI | `submitProductContext()` |
| Desktop → 网页 | Desktop 侧栏点击「填充表单 / 写入商品」 | 内置 `message` 监听 + 可选 `onCommand()` |

---

## 2. 前置条件

### 2.1 运行环境

1. 启动 copilot-desktop（`npm run dev`）
2. 在 **WebOperator** 中打开你的页面（不要用系统浏览器单独访问）
3. 页面 origin 必须在 Desktop 白名单中

默认白名单（见 `copilot-desktop/resources/crm-bridge/crm-bridge.config.json`）：

```text
http://localhost:3000
http://127.0.0.1:3000
http://localhost:5178
http://127.0.0.1:5178
```

接入新站点时，在 Desktop 配置中追加你的 origin，例如 `https://crm.example.com`。

### 2.2 引入 SDK

在页面 `</body>` 前加载（纯 JS，无构建依赖）：

```html
<script src="/assets/crm-lite-jssdk.js"></script>
```

也可复制 `crm-lite-jssdk.js` 到你自己的静态资源目录，或通过 CDN 托管。**copilot-desktop 在导航到白名单 origin 时也会自动注入同一份脚本**（若页面已引入则跳过重复执行）。

---

## 3. 全局对象 `window.CopilotCrmDesktopSDK`

SDK 加载后暴露：

| 成员 | 类型 | 说明 |
|------|------|------|
| `version` | `string` | SDK 版本，默认 `0.2.0` |
| `isAvailable()` | `() => boolean` | Bridge 是否可用 |
| `isDesktopAvailable()` | `() => boolean` | 同上（兼容别名） |
| `submitProductContext(product, options?)` | `(object, object?) => Promise` | 上报商品上下文到 Desktop |
| `onCommand(handler)` | `(fn) => unsubscribe` | 注册额外 command 处理器 |
| `mockElectronCommand(command)` | `(object) => void` | 本地模拟 Desktop 下发命令 |

Bridge 是否可用取决于 Preload 是否注入：

```js
window.CopilotDesktopCRM   // 由 copilot-desktop Preload 提供，非 SDK 创建
```

---

## 4. 检测 Bridge 状态（推荐写法）

不要只在页面加载时检测一次——Preload 可能稍晚就绪。监听 SDK 派发的自定义事件：

```html
<span id="bridgeStatus">检测中…</span>
```

```js
function updateStatus(available) {
  document.getElementById('bridgeStatus').textContent = available
    ? 'Electron Bridge 可用'
    : '普通浏览器 / 未检测到 Electron Bridge';
}

// SDK 在 load / focus / 100ms / 500ms 时会广播
window.addEventListener('crm-lite:bridge-status', function (e) {
  updateStatus(e.detail && e.detail.available);
});

// 首次兜底
var sdk = window.CopilotCrmDesktopSDK;
updateStatus(sdk && sdk.isDesktopAvailable && sdk.isDesktopAvailable());
```

`e.detail.mode`：`"electron"` 或 `"browser"`。

---

## 5. 网页 → Desktop：上报商品上下文

### 5.1 最简示例

```js
document.getElementById('btnSync').addEventListener('click', async function () {
  var product = {
    id: 'P-001',
    sku: 'PHONE-APPLE-15P',
    brand: 'Apple',
    model: 'iPhone 15 Pro',
    productName: 'Apple iPhone 15 Pro 256GB',
    retailPrice: 7999,
    suppliers: [
      { supplierId: 'SUP-001', supplierName: '华芯供应链', supplyPrice: 4200, stockQty: 100 }
    ]
  };

  var result = await window.CopilotCrmDesktopSDK.submitProductContext(product, {
    triggerElementId: 'btnSync',
    triggerLabel: '同步到 Electron'
  });

  console.log('bridge result', result);
  // Bridge 正常：{ ok: true, ... }
  // 无 Preload：{ ok: false, bridge: 'postMessage-fallback', ... }
});
```

### 5.2 实际上报的事件结构

SDK 内部构造 `crm.product.context.submit` 事件：

```js
{
  source: 'crm-web',
  sdkVersion: '0.2.0',
  requestId: 'req_1710000000000',
  type: 'crm.product.context.submit',
  trigger: {
    type: 'user-click',
    elementId: 'btnSync',
    label: '同步到 Electron',
    timestamp: '2026-06-01T10:00:00.000Z'
  },
  page: {
    app: 'crm-lite',
    entityType: 'product',
    entityId: 'P-001',
    entityName: 'Apple iPhone 15 Pro 256GB',
    url: 'http://localhost:3000/product-view.html?id=P-001',
    title: document.title
  },
  payload: { product: { /* 完整商品对象 */ } }
}
```

Desktop 侧 **CrmEventPanel** 收到后会展示商品 ID、名称、SKU、品牌、供应商数量等。

### 5.3 注意事项

- `submitProductContext` 需在**用户点击**后调用（Desktop 有 trusted gesture 窗口，约 1.5s）
- `product` 建议包含业务侧完整字段；Demo 至少要有 `sku` 供 schema 校验
- 其他站点若上报非商品实体，需同步扩展 copilot-desktop 契约（事件类型 / `page.app` / schema）——本 SDK 当前固定为 `crm-lite` + `product`

---

## 6. Desktop → 网页：接收 Command

### 6.1 Desktop 下发的命令格式

经 Preload 转发为 `window.postMessage`：

```js
{
  source: 'copilot-desktop',
  channel: 'crm.desktop.command',
  command: {
    commandId: 'cmd_1710000000000',
    type: 'desktop.crm.product.fillForm',   // 或 desktop.crm.product.create
    payload: {
      product: { sku: '...', brand: '...', /* ... */ }
    },
    createdAt: '2026-06-01T10:00:00.000Z',
    expectAck: true   // create 类命令可能要求回执
  },
  replyRequired: true
}
```

### 6.2 SDK 内置支持的命令

| type | 行为 |
|------|------|
| `desktop.crm.product.fillForm` | 按字段名填充 DOM 表单，并触发 `crm-lite:product-filled` |
| `desktop.crm.product.create` | 填充表单 → `POST /api/products` → 回 ack → 跳转详情页（Demo 专用） |

**DOM 约定（fillForm）：** SDK 按以下顺序查找控件：

```text
[name="sku"]  →  #sku  →  [data-field="sku"]
```

内置字段名：`sku`, `brand`, `model`, `productName`, `series`, `os`, `chipset`, `screenSize`, `ram`, `storage`, `color`, `batteryMah`, `network`, `retailPrice`, `status`, `launchDate`, `description`。

### 6.3 与 UI 框架协作（Layui / React 等）

SDK 只写原生 `input.value`。若使用 Layui、Ant Design Form 等，监听 `crm-lite:product-filled` 再同步到框架：

```js
layui.use(['form'], function () {
  var form = layui.form;

  window.addEventListener('crm-lite:product-filled', function (e) {
    var product = e.detail && e.detail.product;
    if (!product) return;
    form.val('productForm', product);  // 同步 Layui 表单
    form.render('select');
    // 自行更新子表、本地 state 等
  });
});
```

### 6.4 自定义 command 处理（`onCommand`）

SDK 内置处理器执行后，仍会调用你注册的 handler：

```js
var off = window.CopilotCrmDesktopSDK.onCommand(async function (command) {
  console.log('收到 command', command.type, command.payload);

  if (command.type === 'desktop.crm.product.fillForm') {
    // 除 SDK 默认 fill 外，做额外 UI 逻辑
  }

  if (command.type === 'desktop.crm.product.create') {
    // 若不用 Demo 的 /api/products，可在此走自己的保存 API
  }
});

// 页面卸载时取消订阅
// off();
```

### 6.5 Command 回执（ack）

当 `replyRequired: true` 时，SDK 处理完毕会自动：

```js
window.postMessage({
  source: 'copilot-crm-jssdk',
  channel: 'crm.desktop.command.result',
  result: {
    commandId: 'cmd_...',
    ok: true,
    type: 'desktop.crm.product.create',
    action: 'crm.product.create',
    data: { /* 保存后的商品 */ },
    receivedAt: '...',
    completedAt: '...'
  }
}, location.origin);
```

Preload 转发给 Main；Desktop 侧栏不再出现 `COMMAND_ACK_TIMEOUT`。

### 6.6 调试日志区域（可选）

SDK 会写入以下元素之一（存在则更新文本）：

```html
<pre id="bridgeLog"></pre>
<!-- 或 -->
<pre id="electronBridgeLog"></pre>
<!-- 或 -->
<pre data-electron-bridge-log></pre>
```

---

## 7. 本地无 Desktop 调试

### 7.1 模拟 Desktop 下发命令

```js
window.CopilotCrmDesktopSDK.mockElectronCommand({
  commandId: 'cmd_' + Date.now(),
  type: 'desktop.crm.product.fillForm',
  payload: {
    product: {
      sku: 'PHONE-TEST-001',
      brand: 'Test',
      model: 'X1',
      productName: 'Test Phone X1'
    }
  },
  createdAt: new Date().toISOString()
});
```

等价于 Desktop 侧 postMessage，可在 Chrome 里验证表单填充逻辑。

### 7.2 模拟上报（无 Preload）

普通浏览器中 `submitProductContext` 会走 postMessage fallback，返回：

```js
{ ok: false, bridge: 'postMessage-fallback', message: '...' }
```

完整链路必须在 copilot-desktop WebOperator 中验证。

---

## 8. 其它网站最小接入模板

### 8.1 只读页：把选中数据同步给 Desktop

```html
<!doctype html>
<html>
<head><meta charset="utf-8"><title>客户详情</title></head>
<body>
  <button id="syncBtn">同步到 Copilot</button>
  <script src="https://your-cdn.example.com/crm-lite-jssdk.js"></script>
  <script>
    var record = { id: 'C-100', name: 'Acme Corp', industry: 'SaaS' };

    document.getElementById('syncBtn').onclick = function () {
      // 当前 SDK 封装为商品；通用场景可直接构造 event 走 CopilotDesktopCRM.emit
      window.CopilotCrmDesktopSDK.submitProductContext(
        { id: record.id, productName: record.name, sku: 'CUSTOM-' + record.id, brand: record.industry },
        { triggerElementId: 'syncBtn', triggerLabel: '同步客户' }
      );
    };
  </script>
</body>
</html>
```

> 生产环境若实体不是「商品」，应在 copilot-desktop 扩展事件类型后，自行调用 `window.CopilotDesktopCRM.emit(event)` 构造合规 payload。

### 8.2 表单页：接收 Desktop 填充

```html
<form id="leadForm">
  <input name="sku" placeholder="SKU">
  <input name="brand" placeholder="品牌">
  <input name="productName" placeholder="名称">
</form>

<script src="/assets/crm-lite-jssdk.js"></script>
<script>
  window.addEventListener('crm-lite:bridge-status', function (e) {
    console.log('bridge', e.detail);
  });

  // 可选：覆盖默认 create 行为
  window.CopilotCrmDesktopSDK.onCommand(function (cmd) {
    if (cmd.type === 'desktop.crm.product.fillForm') {
      console.log('表单已被 Desktop 填充', cmd.payload.product);
    }
  });
</script>
```

### 8.3 自定义事件一览

| 事件名 | 触发时机 | `detail` |
|--------|----------|----------|
| `crm-lite:bridge-status` | Bridge 状态变化 | `{ available: boolean, mode: 'electron' \| 'browser' }` |
| `crm-lite:product-filled` | fillForm / create 填充字段后 | `{ product: object }` |
| `crm-lite:desktop-command` | 收到 Desktop command（Hermes SDK 扩展用） | command 对象 |

---

## 9. 接入检查清单

- [ ] 页面 origin 已加入 `crm-bridge.config.json` 的 `allowedOrigins`
- [ ] 在 copilot-desktop **WebOperator** 内打开页面（非 standalone 浏览器）
- [ ] 控制台可见 `[CRM-BRIDGE-PRELOAD] script evaluating`
- [ ] `window.CopilotDesktopCRM` 存在
- [ ] `CopilotCrmDesktopSDK.isDesktopAvailable()` 为 `true`
- [ ] 表单字段使用 `name="sku"` 等与 SDK 一致的命名
- [ ] UI 框架通过 `crm-lite:product-filled` 二次同步
- [ ] 用户点击触发 `submitProductContext`（非定时器自动上报）

---

## 10. 常见问题

**Q：状态一直显示「未检测到 Electron Bridge」**

- 确认在 WebOperator 内打开，且 Desktop 已 rebuild（`npm run dev`）
- DevTools 执行 `window.CopilotDesktopCRM`，应为对象而非 `undefined`
- 完全退出 Desktop 后重开（旧 WebContentsView 可能未带 Preload）

**Q：Desktop 显示 command 已发送，页面无反应**

- 检查 `#bridgeLog` 是否有 command JSON
- 表单是否有匹配的 `[name="sku"]` 等字段
- Layui/React 是否监听了 `crm-lite:product-filled`

**Q：`COMMAND_ACK_TIMEOUT`**

- 通常是 command 处理抛错或未回 ack；看 bridgeLog 里的 `command error`
- Demo 的 `create` 依赖 `POST /api/products` 返回 `{ code:0, data:{ id } }`

**Q：能否不用商品模型？**

- 本 SDK 面向 Demo 商品场景；其它实体请扩展 Desktop 契约后，直接使用 `CopilotDesktopCRM.emit()` 发送自定义 `type` / `page.entityType`

---

## 11. 相关文件

| 文件 | 说明 |
|------|------|
| `public/assets/crm-lite-jssdk.js` | 页面 SDK（可复制到其他项目） |
| `copilot-desktop/resources/crm-bridge/crm-lite-jssdk.js` | Desktop 注入用副本，应与页面 SDK 保持同步 |
| `copilot-desktop/src/preload/crm-bridge-preload.ts` | Preload Bridge（网站无需引入） |
| `copilot-desktop/resources/crm-bridge/crm-bridge.config.json` | origin / 事件类型白名单 |

---

## 12. 版本

- SDK：`0.2.0`（与 `CopilotDesktopCRM.version` 对齐）
- 配套 copilot-desktop：**V5.7.10** CRM-Lite Bridge Demo

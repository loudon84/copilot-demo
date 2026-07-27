# 供应商平台 Demo（AutoTask RPA 测试目标系统）

该工程基于 `vue-admin-template` 的 Vue2 + Element UI 目录结构实现，用于 AutoTask / Playwright RPA 功能测试。

## 已实现页面

1. 登录页：`/login`
2. 供应商首页 Dashboard：`/dashboard`
3. 订单列表：`/supplier/orders`
4. 订单详情页：`/supplier/orders/:orderNo`
5. 订单直发：`/supplier/order-direct`
6. 发货单：`/supplier/deliveries`
7. 收货列表：`/supplier/receivings`
8. 对账单：`/finance/reconciliation`
9. 模拟下载文件
10. Mock API + Mock 数据

## 演示账号

```text
账号：admin
密码：123456
验证码：8888
```

## 启动

```bash
cd source
npm install
npm run dev
```

默认端口：`http://localhost:9528`

## 下载文件固定路径配置

下载按钮不会生成真实业务文件，而是指向固定文件地址。修改：

```text
src/config/download.js
```

默认文件放在：

```text
public/mock-downloads/
```

如需替换为你们本地文件服务：

```js
export const DOWNLOAD_FILE_CONFIG = {
  baseUrl: 'http://127.0.0.1:18082/files',
  files: {
    orderExport: { filename: 'order-export.csv', url: 'order-export.csv' },
    deliveryNote: { filename: 'delivery-note.csv', url: 'delivery-note.csv' },
    reconciliationExport: { filename: 'reconciliation-export.csv', url: 'reconciliation-export.csv' }
  }
}
```

## RPA Selector

所有关键元素都增加了稳定 `data-rpa` 属性。建议 Playwright 优先使用：

```ts
await page.locator('[data-rpa="login-username"]').fill('admin')
await page.locator('[data-rpa="login-password"]').fill('123456')
await page.locator('[data-rpa="login-captcha"]').fill('8888')
await page.locator('[data-rpa="login-submit"]').click()
await page.locator('[data-rpa="menu-order-list"]').click()
await page.locator('[data-rpa="order-no-input"]').fill('POJS2606030010')
await page.locator('[data-rpa="order-search-btn"]').click()
await page.locator('[data-rpa="order-detail-POJS2606030010"]').click()
await page.locator('[data-rpa="order-detail-page"]').waitFor()
```

## 推荐 RPA 主链路

1. 登录 `/login`
2. 进入 `/dashboard`
3. 点击订单列表
4. 查询 `POJS2606030010`
5. 点击详情进入订单详情页，校验订单基础信息和物料明细
6. 在详情页点击下推发货单
7. 跳转发货单页并下载送货单
8. 进入收货列表
9. 查询 `POJS2604230001`
10. 勾选收货行并生成对账单
11. 跳转对账单页
12. 点击收货应付
13. 下载对账文件

## Mock 数据位置

```text
mock/supplier.js
src/api/supplier.js
```

`src/api/supplier.js` 返回 Promise，模拟接口延迟，页面不直接读取业务数据。

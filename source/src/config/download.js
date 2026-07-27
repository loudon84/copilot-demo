// 修改这里即可把“导出 / 下载”按钮指向你们环境中的固定文件路径。
// 例如：baseUrl: 'http://127.0.0.1:18082/files'，或把单个 url 改成完整 http 地址。
export const DOWNLOAD_FILE_CONFIG = {
  baseUrl: process.env.VUE_APP_DOWNLOAD_BASE || '/mock-downloads',
  files: {
    orderExport: {
      label: '订单导出文件',
      filename: 'order-20260709122735.xlsx',
      url: 'order-20260709122735.xlsx'
    },
    orderPOJS2607130002: {
      label: '订单 POJS2607130002 明细',
      filename: 'order_POJS2607130002.xlsx',
      url: 'order_POJS2607130002.xlsx'
    },
    deliveryNote: {
      label: '送货单文件',
      filename: 'delivery-note.csv',
      url: 'delivery-note.csv'
    },
    reconciliationExport: {
      label: '对账单导出文件',
      filename: 'reconciliation-20260709122723.xlsx',
      url: 'reconciliation-20260709122723.xlsx'
    }
  }
}

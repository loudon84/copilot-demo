import supplierMock from '../../mock/supplier'

function clone(data) {
  return JSON.parse(JSON.stringify(data))
}

function mockResponse(data, delay = 180) {
  return new Promise(resolve => {
    setTimeout(() => resolve({ code: 20000, data: clone(data) }), delay)
  })
}

function includesValue(source, target) {
  if (!target && target !== 0) return true
  return String(source || '').toLowerCase().indexOf(String(target).toLowerCase()) !== -1
}

function inDateRange(dateText, range) {
  if (!range || range.length !== 2) return true
  const date = new Date(dateText).getTime()
  const start = new Date(range[0]).getTime()
  const end = new Date(range[1]).getTime()
  return date >= start && date <= end
}

function paginate(list, params = {}) {
  const page = Number(params.page || 1)
  const limit = Number(params.limit || 10)
  const start = (page - 1) * limit
  return {
    total: list.length,
    items: list.slice(start, start + limit)
  }
}

export function fetchDashboard() {
  const orders = supplierMock.orders
  const deliveries = supplierMock.deliveries
  const receivings = supplierMock.receivings
  const reconciliations = supplierMock.reconciliations
  const data = {
    cards: [
      { title: '待回签订单', value: orders.filter(item => item.replyStatus !== '已回签').length, type: 'warning' },
      { title: '待发货订单', value: orders.filter(item => item.deliveryStatus !== '已发货').length, type: 'primary' },
      { title: '待生成对账', value: receivings.filter(item => item.reconciliationStatus === '未提交').length, type: 'danger' },
      { title: '本月对账单', value: reconciliations.length, type: 'success' }
    ],
    recentOrders: orders.slice(0, 6),
    recentDeliveries: deliveries.slice(0, 5),
    pendingReceivings: receivings.filter(item => item.reconciliationStatus === '未提交').slice(0, 5),
    notices: supplierMock.notices
  }
  return mockResponse(data)
}

export function fetchOrders(params = {}) {
  let list = supplierMock.orders.filter(item => {
    return includesValue(item.orderNo, params.orderNo) &&
      (!params.orderType || item.orderType === params.orderType) &&
      (!params.replyStatus || item.replyStatus === params.replyStatus) &&
      (!params.deliveryStatus || item.deliveryStatus === params.deliveryStatus) &&
      inDateRange(item.orderDate, params.dateRange)
  })
  return mockResponse(paginate(list, params))
}


export function fetchOrderDetail(orderNo) {
  const order = supplierMock.orders.find(item => item.orderNo === orderNo) || supplierMock.orderDirects.find(item => item.orderNo === orderNo)
  if (!order) {
    return mockResponse({ order: null, lines: [] })
  }
  const lines = supplierMock.orderLines[orderNo] || [
    {
      lineNo: '10',
      materialNo: 'MOCK-0001',
      materialName: order.materialSummary || '订单物料',
      materialSpec: '标准规格',
      unit: 'PCS',
      orderQty: order.deliveryQty || 1,
      deliveredQty: order.deliveryStatus === '已发货' ? (order.deliveryQty || 1) : 0,
      undeliveredQty: order.deliveryStatus === '已发货' ? 0 : (order.deliveryQty || 1),
      unitPrice: Number(order.totalAmount || 0) / Number(order.deliveryQty || 1),
      taxRate: '13%',
      amount: Number(order.totalAmount || 0),
      deliveryDate: order.orderDate
    }
  ]
  return mockResponse({ order, lines })
}

export function fetchOrderDirect(params = {}) {
  let list = supplierMock.orderDirects.filter(item => {
    return includesValue(item.orderNo, params.orderNo) &&
      includesValue(item.directCustomer, params.directCustomer) &&
      (!params.deliveryStatus || item.deliveryStatus === params.deliveryStatus) &&
      inDateRange(item.orderDate, params.dateRange)
  })
  return mockResponse(paginate(list, params))
}

export function fetchDeliveries(params = {}) {
  let list = supplierMock.deliveries.filter(item => {
    return includesValue(item.deliveryNo, params.deliveryNo) &&
      includesValue(item.orderNo, params.orderNo) &&
      (!params.deliveryStatus || item.deliveryStatus === params.deliveryStatus) &&
      inDateRange(item.deliveryDate, params.dateRange)
  })
  return mockResponse(paginate(list, params))
}

export function fetchReceivings(params = {}) {
  let list = supplierMock.receivings.filter(item => {
    return includesValue(item.orderNo, params.orderNo) &&
      includesValue(item.receivingNo, params.receivingNo) &&
      includesValue(item.materialNo, params.materialNo) &&
      includesValue(item.materialName, params.materialName) &&
      (!params.reconciliationStatus || item.reconciliationStatus === params.reconciliationStatus) &&
      inDateRange(item.confirmedAt, params.dateRange)
  })
  return mockResponse(paginate(list, params))
}

export function fetchReconciliations(params = {}) {
  let list = supplierMock.reconciliations.filter(item => {
    return includesValue(item.reconciliationNo, params.reconciliationNo) &&
      (!params.reconciliationStatus || item.reconciliationStatus === params.reconciliationStatus) &&
      (!params.invoiceStatus || item.invoiceStatus === params.invoiceStatus) &&
      inDateRange(item.reconciliationDate, params.dateRange)
  })
  return mockResponse(paginate(list, params))
}

export function saveOrderExpectedDates(data = {}) {
  const orderNo = data.orderNo
  const order = supplierMock.orders.find(item => item.orderNo === orderNo)
  if (!order) {
    return mockResponse({ order: null, lines: [] })
  }
  const lines = supplierMock.orderLines[orderNo]
  const saved = []
  if (lines && Array.isArray(data.lines)) {
    data.lines.forEach(row => {
      const target = lines.find(item => String(item.lineNo) === String(row.lineNo))
      if (target) {
        target.expectedDeliveryDate = row.expectedDeliveryDate || ''
        saved.push({
          lineNo: target.lineNo,
          expectedDeliveryDate: target.expectedDeliveryDate
        })
      }
    })
  }
  return mockResponse({
    order,
    lines: supplierMock.orderLines[orderNo] || [],
    saved
  })
}

export function signOrder(data = {}) {
  const orderNo = data.orderNo
  const order = supplierMock.orders.find(item => item.orderNo === orderNo)
  if (!order) {
    return mockResponse({ order: null, lines: [] })
  }
  const lines = supplierMock.orderLines[orderNo]
  if (lines && Array.isArray(data.lines)) {
    data.lines.forEach(row => {
      const target = lines.find(item => String(item.lineNo) === String(row.lineNo))
      if (target) {
        target.expectedDeliveryDate = row.expectedDeliveryDate || ''
      }
    })
  }
  order.replyStatus = '已回签'
  return mockResponse({
    order,
    lines: supplierMock.orderLines[orderNo] || []
  })
}

export function pushDelivery(data = {}) {
  const selectedOrders = data.orders || []
  const order = selectedOrders[0] || supplierMock.orders[0]
  const deliveryNo = `DN${String(order.orderNo || '2600000000').replace(/^POJS/, '')}`
  if (!supplierMock.deliveries.find(item => item.deliveryNo === deliveryNo)) {
    supplierMock.deliveries.unshift({
      deliveryNo,
      orderNo: order.orderNo,
      deliveryDate: new Date().toISOString().slice(0, 10),
      deliveryQty: order.deliveryQty || 120,
      boxCount: 8,
      logisticsCompany: '顺丰速运',
      trackingNo: `SF${Date.now().toString().slice(-8)}`,
      deliveryStatus: '待发货',
      ownerOrg: order.ownerOrg || '天津天地伟业数码科技有限公司'
    })
  }
  return mockResponse({ deliveryNo })
}

export function generateReconciliation(data = {}) {
  const selectedReceivings = data.receivings || []
  const first = selectedReceivings[0] || supplierMock.receivings[0]
  const reconciliationNo = `RC${Date.now().toString().slice(-10)}`
  const amount = selectedReceivings.reduce((sum, item) => sum + Number(item.payableTotal || 0), 0) || Number(first.payableTotal || 0)
  supplierMock.reconciliations.unshift({
    reconciliationNo,
    reconciliationDate: new Date().toISOString().slice(0, 10),
    reconciliationStatus: '未提交',
    invoiceStatus: '未上传',
    invoiceAmount: 0,
    reconciliationAmount: amount,
    lastStorageTime: first.confirmedAt,
    ownerOrg: first.ownerOrg || '天津天地伟业数码科技有限公司'
  })
  selectedReceivings.forEach(row => {
    const target = supplierMock.receivings.find(item => item.id === row.id)
    if (target) target.reconciliationStatus = '已提交'
  })
  return mockResponse({ reconciliationNo })
}

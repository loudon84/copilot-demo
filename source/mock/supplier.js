const orders = [
  {
    id: 'order_011',
    orderNo: 'POJS2607130002',
    orderDate: '2026-07-13',
    orderType: '普通订单',
    terminated: '否',
    totalAmount: 84208626.83,
    replyStatus: '待签章',
    deliveryStatus: '未发货',
    ownerOrg: '天地伟业技术有限公司',
    deliveryQty: 1947543,
    materialSummary: '芯片-视频编解码'
  },
  {
    id: 'order_001',
    orderNo: 'POJS2606030010',
    orderDate: '2026-06-03',
    orderType: '普通订单',
    terminated: '否',
    totalAmount: 125860.00,
    replyStatus: '待回签',
    deliveryStatus: '未发货',
    ownerOrg: '天津天地伟业数码科技有限公司',
    deliveryQty: 260,
    materialSummary: '网络摄像机组件 / 安装支架'
  },
  {
    id: 'order_002',
    orderNo: 'POJS2604230016',
    orderDate: '2026-04-23',
    orderType: '普通订单',
    terminated: '否',
    totalAmount: 78540.00,
    replyStatus: '已回签',
    deliveryStatus: '部分发货',
    ownerOrg: '天津天地伟业科技有限公司',
    deliveryQty: 180,
    materialSummary: '硬盘录像机结构件'
  },
  {
    id: 'order_003',
    orderNo: 'POJS2604230015',
    orderDate: '2026-04-23',
    orderType: '普通订单',
    terminated: '否',
    totalAmount: 43210.50,
    replyStatus: '已回签',
    deliveryStatus: '已发货',
    ownerOrg: '天津天地伟业数码科技有限公司',
    deliveryQty: 90,
    materialSummary: '交换机外壳'
  },
  {
    id: 'order_004',
    orderNo: 'POJS2604230014',
    orderDate: '2026-04-23',
    orderType: '普通订单',
    terminated: '否',
    totalAmount: 61800.00,
    replyStatus: '退回',
    deliveryStatus: '未发货',
    ownerOrg: '天津天地伟业科技有限公司',
    deliveryQty: 110,
    materialSummary: '线束组件'
  },
  {
    id: 'order_005',
    orderNo: 'POJS2604230013',
    orderDate: '2026-04-23',
    orderType: '普通订单',
    terminated: '否',
    totalAmount: 91000.00,
    replyStatus: '待签章',
    deliveryStatus: '超期未发货',
    ownerOrg: '天津天地伟业数码科技有限公司',
    deliveryQty: 210,
    materialSummary: '摄像机镜头组件'
  },
  {
    id: 'order_006',
    orderNo: 'POJS2604230001',
    orderDate: '2026-04-23',
    orderType: '普通订单',
    terminated: '否',
    totalAmount: 32600.00,
    replyStatus: '已回签',
    deliveryStatus: '已发货',
    ownerOrg: '天津天地伟业科技有限公司',
    deliveryQty: 75,
    materialSummary: '电源适配器'
  },
  {
    id: 'order_007',
    orderNo: 'POJS2603200006',
    orderDate: '2026-03-20',
    orderType: '普通订单',
    terminated: '否',
    totalAmount: 152300.00,
    replyStatus: '已回签',
    deliveryStatus: '部分发货',
    ownerOrg: '天津天地伟业数码科技有限公司',
    deliveryQty: 300,
    materialSummary: '包装材料'
  },
  {
    id: 'order_008',
    orderNo: 'POJS2602260351',
    orderDate: '2026-02-26',
    orderType: '普通订单',
    terminated: '否',
    totalAmount: 56000.00,
    replyStatus: '待回签',
    deliveryStatus: '未发货',
    ownerOrg: '天津天地伟业科技有限公司',
    deliveryQty: 88,
    materialSummary: '安装附件'
  },
  {
    id: 'order_009',
    orderNo: 'POJS2601300015',
    orderDate: '2026-01-30',
    orderType: '普通订单',
    terminated: '否',
    totalAmount: 188400.00,
    replyStatus: '已回签',
    deliveryStatus: '已发货',
    ownerOrg: '天津天地伟业数码科技有限公司',
    deliveryQty: 420,
    materialSummary: '整机结构组件'
  },
  {
    id: 'order_010',
    orderNo: 'POJS2601230020',
    orderDate: '2026-01-23',
    orderType: '普通订单',
    terminated: '否',
    totalAmount: 45800.00,
    replyStatus: '已回签',
    deliveryStatus: '已发货',
    ownerOrg: '天津天地伟业科技有限公司',
    deliveryQty: 130,
    materialSummary: '紧固件'
  }
]


const orderLines = {
  POJS2607130002: [
    {
      lineNo: '10',
      materialNo: '1B.30040.020262',
      materialName: '芯片-视频编解码',
      materialSpec: '[SSC336Q]-(C)-QFN128(12.3x12.3mm)-sigmastar',
      unit: '个',
      orderQty: 48640,
      deliveredQty: 0,
      undeliveredQty: 48640,
      unitPrice: 96.9727,
      taxRate: '13%',
      amount: 4716752.13,
      deliveryDate: '2026-07-20',
      expectedDeliveryDate: ''
    },
    {
      lineNo: '20',
      materialNo: '1B.30040.020255',
      materialName: '芯片-视频编解码',
      materialSpec: '[SSC373]-(C)-QFN88(9x9mm)-sigmastar',
      unit: '个',
      orderQty: 576163,
      deliveredQty: 0,
      undeliveredQty: 576163,
      unitPrice: 36.8496,
      taxRate: '13%',
      amount: 21231376.08,
      deliveryDate: '2026-07-15',
      expectedDeliveryDate: ''
    },
    {
      lineNo: '30',
      materialNo: '1B.30040.020257',
      materialName: '芯片-视频编解码',
      materialSpec: '[SSC373A]-(C)-QFN88(9x9mm)-sigmastar',
      unit: '个',
      orderQty: 137447,
      deliveredQty: 0,
      undeliveredQty: 137447,
      unitPrice: 36.8496,
      taxRate: '13%',
      amount: 5064866.97,
      deliveryDate: '2026-07-15',
      expectedDeliveryDate: ''
    },
    {
      lineNo: '40',
      materialNo: '1B.30040.020260',
      materialName: '芯片-视频编解码',
      materialSpec: '[SSC375]-(C)-QFN88(9x9mm)-sigmastar',
      unit: '个',
      orderQty: 443040,
      deliveredQty: 0,
      undeliveredQty: 443040,
      unitPrice: 36.8496,
      taxRate: '13%',
      amount: 16325846.78,
      deliveryDate: '2026-07-15',
      expectedDeliveryDate: ''
    },
    {
      lineNo: '50',
      materialNo: '1B.30040.020258',
      materialName: '芯片-视频编解码',
      materialSpec: '[SSC375A]-(C)-QFN88(9x9mm)-sigmastar',
      unit: '个',
      orderQty: 500493,
      deliveredQty: 0,
      undeliveredQty: 500493,
      unitPrice: 36.8496,
      taxRate: '13%',
      amount: 18442966.85,
      deliveryDate: '2026-07-20',
      expectedDeliveryDate: ''
    },
    {
      lineNo: '60',
      materialNo: '1B.30040.020259',
      materialName: '芯片-视频编解码',
      materialSpec: '[SSC377]-(C)-600万-QFN88(9x9mm)-sigmastar',
      unit: '个',
      orderQty: 10400,
      deliveredQty: 0,
      undeliveredQty: 10400,
      unitPrice: 47.2046,
      taxRate: '13%',
      amount: 490927.84,
      deliveryDate: '2026-07-20',
      expectedDeliveryDate: ''
    },
    {
      lineNo: '70',
      materialNo: '1B.30040.020256',
      materialName: '芯片-视频编解码',
      materialSpec: '[SSC377D]-(C)-600万-QFN88(9x9mm)-sigmastar',
      unit: '个',
      orderQty: 91520,
      deliveredQty: 0,
      undeliveredQty: 91520,
      unitPrice: 56.1039,
      taxRate: '13%',
      amount: 5134628.93,
      deliveryDate: '2026-07-20',
      expectedDeliveryDate: ''
    },
    {
      lineNo: '80',
      materialNo: '1B.30040.020261',
      materialName: '芯片-视频编解码',
      materialSpec: '[SSR621Q]-(C)-QFN128(12.3x12.3mm)-sigmastar',
      unit: '个',
      orderQty: 139840,
      deliveredQty: 0,
      undeliveredQty: 139840,
      unitPrice: 91.5422,
      taxRate: '13%',
      amount: 12801261.25,
      deliveryDate: '2026-07-20',
      expectedDeliveryDate: ''
    }
  ],
  POJS2606030010: [
    {
      lineNo: '10',
      materialNo: 'MAT-IPC-260603-01',
      materialName: '网络摄像机组件',
      materialSpec: 'IPC-TD-4MP/POE',
      unit: 'PCS',
      orderQty: 160,
      deliveredQty: 0,
      undeliveredQty: 160,
      unitPrice: 486.00,
      taxRate: '13%',
      amount: 77760.00,
      deliveryDate: '2026-06-18'
    },
    {
      lineNo: '20',
      materialNo: 'MAT-BKT-260603-02',
      materialName: '安装支架',
      materialSpec: '壁装支架 / 白色喷涂',
      unit: 'PCS',
      orderQty: 100,
      deliveredQty: 0,
      undeliveredQty: 100,
      unitPrice: 481.00,
      taxRate: '13%',
      amount: 48100.00,
      deliveryDate: '2026-06-18'
    }
  ],
  POJS2604230016: [
    {
      lineNo: '10',
      materialNo: 'MAT-NVR-260423-01',
      materialName: '硬盘录像机结构件',
      materialSpec: 'NVR-16CH / 黑色',
      unit: 'PCS',
      orderQty: 180,
      deliveredQty: 90,
      undeliveredQty: 90,
      unitPrice: 436.33,
      taxRate: '13%',
      amount: 78540.00,
      deliveryDate: '2026-05-10'
    }
  ],
  POJS2604230015: [
    {
      lineNo: '10',
      materialNo: 'MAT-SW-260423-01',
      materialName: '交换机外壳',
      materialSpec: '8 口工业交换机',
      unit: 'PCS',
      orderQty: 90,
      deliveredQty: 90,
      undeliveredQty: 0,
      unitPrice: 480.12,
      taxRate: '13%',
      amount: 43210.50,
      deliveryDate: '2026-05-05'
    }
  ],
  POJS2604230014: [
    {
      lineNo: '10',
      materialNo: 'MAT-WIRE-260423-01',
      materialName: '线束组件',
      materialSpec: 'T 系列主板线束',
      unit: 'PCS',
      orderQty: 110,
      deliveredQty: 0,
      undeliveredQty: 110,
      unitPrice: 561.82,
      taxRate: '13%',
      amount: 61800.00,
      deliveryDate: '2026-05-15'
    }
  ],
  POJS2604230013: [
    {
      lineNo: '10',
      materialNo: 'MAT-LENS-260423-01',
      materialName: '摄像机镜头组件',
      materialSpec: '4mm 定焦镜头',
      unit: 'PCS',
      orderQty: 210,
      deliveredQty: 0,
      undeliveredQty: 210,
      unitPrice: 433.33,
      taxRate: '13%',
      amount: 91000.00,
      deliveryDate: '2026-05-12'
    }
  ],
  POJS2604230001: [
    {
      lineNo: '10',
      materialNo: 'MAT-PWR-260423-01',
      materialName: '电源适配器',
      materialSpec: '12V/2A',
      unit: 'PCS',
      orderQty: 50,
      deliveredQty: 50,
      undeliveredQty: 0,
      unitPrice: 120.00,
      taxRate: '13%',
      amount: 6000.00,
      deliveryDate: '2026-04-30'
    },
    {
      lineNo: '20',
      materialNo: 'MAT-BKT-260423-02',
      materialName: '安装支架',
      materialSpec: 'T 系列通用',
      unit: 'PCS',
      orderQty: 25,
      deliveredQty: 25,
      undeliveredQty: 0,
      unitPrice: 96.00,
      taxRate: '13%',
      amount: 2400.00,
      deliveryDate: '2026-04-30'
    }
  ],
  POJS2603200006: [
    {
      lineNo: '10',
      materialNo: 'MAT-PKG-260320-01',
      materialName: '包装材料',
      materialSpec: '摄像机彩盒 + 内托',
      unit: 'PCS',
      orderQty: 300,
      deliveredQty: 150,
      undeliveredQty: 150,
      unitPrice: 507.67,
      taxRate: '13%',
      amount: 152300.00,
      deliveryDate: '2026-04-05'
    }
  ],
  POJS2602260351: [
    {
      lineNo: '10',
      materialNo: 'MAT-ACC-260226-01',
      materialName: '安装附件',
      materialSpec: '螺丝包 + 标签',
      unit: '套',
      orderQty: 88,
      deliveredQty: 0,
      undeliveredQty: 88,
      unitPrice: 636.36,
      taxRate: '13%',
      amount: 56000.00,
      deliveryDate: '2026-03-15'
    }
  ],
  POJS2601300015: [
    {
      lineNo: '10',
      materialNo: 'MAT-ASM-260130-01',
      materialName: '整机结构组件',
      materialSpec: '云台结构组件',
      unit: 'PCS',
      orderQty: 420,
      deliveredQty: 420,
      undeliveredQty: 0,
      unitPrice: 448.57,
      taxRate: '13%',
      amount: 188400.00,
      deliveryDate: '2026-02-20'
    }
  ],
  POJS2601230020: [
    {
      lineNo: '10',
      materialNo: 'MAT-SCREW-260123-01',
      materialName: '紧固件',
      materialSpec: 'M3/M4 混合包',
      unit: '包',
      orderQty: 130,
      deliveredQty: 130,
      undeliveredQty: 0,
      unitPrice: 352.31,
      taxRate: '13%',
      amount: 45800.00,
      deliveryDate: '2026-02-10'
    }
  ]
}

const orderDirects = [
  {
    id: 'direct_001',
    orderNo: 'ZFD2607010001',
    orderDate: '2026-07-01',
    directCustomer: '天津智慧园区项目部',
    deliveryAddress: '天津市滨海新区海泰发展六道',
    contactName: '刘工',
    contactPhone: '13800000001',
    totalAmount: 26800.00,
    deliveryStatus: '未发货',
    replyStatus: '待回签'
  },
  {
    id: 'direct_002',
    orderNo: 'ZFD2606250007',
    orderDate: '2026-06-25',
    directCustomer: '北京轨道交通项目组',
    deliveryAddress: '北京市丰台区科技园',
    contactName: '王工',
    contactPhone: '13800000002',
    totalAmount: 93500.00,
    deliveryStatus: '部分发货',
    replyStatus: '已回签'
  },
  {
    id: 'direct_003',
    orderNo: 'ZFD2606150003',
    orderDate: '2026-06-15',
    directCustomer: '南京安防集成商',
    deliveryAddress: '南京市江宁区将军大道',
    contactName: '陈工',
    contactPhone: '13800000003',
    totalAmount: 42720.00,
    deliveryStatus: '已发货',
    replyStatus: '已回签'
  }
]

const deliveries = [
  {
    deliveryNo: 'DN2606030010',
    orderNo: 'POJS2606030010',
    deliveryDate: '2026-06-04',
    deliveryQty: 260,
    boxCount: 12,
    logisticsCompany: '顺丰速运',
    trackingNo: 'SF2606030010',
    deliveryStatus: '待发货',
    ownerOrg: '天津天地伟业数码科技有限公司'
  },
  {
    deliveryNo: 'DN2604230016',
    orderNo: 'POJS2604230016',
    deliveryDate: '2026-04-24',
    deliveryQty: 90,
    boxCount: 7,
    logisticsCompany: '德邦快递',
    trackingNo: 'DB2604230016',
    deliveryStatus: '已发货',
    ownerOrg: '天津天地伟业科技有限公司'
  }
]

const receivings = [
  {
    id: 'recv_001',
    orderNo: 'POJS2604230001',
    receivingNo: 'RCV2604300001',
    receivingLineNo: '10',
    reconciliationStatus: '未提交',
    documentType: '采购入库',
    confirmedAt: '2026-04-30',
    materialNo: '10010001',
    materialName: '电源适配器',
    materialSpec: '12V/2A',
    receivedQty: 50,
    unitPrice: 120.00,
    netUnitPrice: 106.19,
    taxRate: '13%',
    payableNetAmount: 5309.50,
    payableTaxAmount: 690.24,
    payableTotal: 5999.74,
    documentDate: '2026-04-30',
    accountQty: 50,
    actualArrivalDate: '2026-04-29',
    ownerOrg: '天津天地伟业科技有限公司'
  },
  {
    id: 'recv_002',
    orderNo: 'POJS2604230001',
    receivingNo: 'RCV2604300002',
    receivingLineNo: '20',
    reconciliationStatus: '未提交',
    documentType: '采购入库',
    confirmedAt: '2026-04-30',
    materialNo: '10010002',
    materialName: '安装支架',
    materialSpec: 'T系列通用',
    receivedQty: 25,
    unitPrice: 96.00,
    netUnitPrice: 84.96,
    taxRate: '13%',
    payableNetAmount: 2123.89,
    payableTaxAmount: 276.11,
    payableTotal: 2400.00,
    documentDate: '2026-04-30',
    accountQty: 25,
    actualArrivalDate: '2026-04-29',
    ownerOrg: '天津天地伟业科技有限公司'
  },
  {
    id: 'recv_003',
    orderNo: 'POJS2604230016',
    receivingNo: 'RCV2605010007',
    receivingLineNo: '10',
    reconciliationStatus: '已提交',
    documentType: '采购入库',
    confirmedAt: '2026-05-01',
    materialNo: '20020001',
    materialName: '硬盘录像机结构件',
    materialSpec: 'NVR-16CH',
    receivedQty: 80,
    unitPrice: 360.00,
    netUnitPrice: 318.58,
    taxRate: '13%',
    payableNetAmount: 25486.40,
    payableTaxAmount: 3313.23,
    payableTotal: 28799.63,
    documentDate: '2026-05-01',
    accountQty: 80,
    actualArrivalDate: '2026-04-30',
    ownerOrg: '天津天地伟业科技有限公司'
  }
]

const reconciliations = [
  {
    reconciliationNo: 'RC2607010001',
    reconciliationDate: '2026-07-01',
    reconciliationStatus: '未提交',
    invoiceStatus: '未上传',
    invoiceAmount: 0,
    reconciliationAmount: 32600.00,
    lastStorageTime: '2026-04-30',
    ownerOrg: '天津天地伟业科技有限公司'
  },
  {
    reconciliationNo: 'RC2607020002',
    reconciliationDate: '2026-07-02',
    reconciliationStatus: '已提交',
    invoiceStatus: '审核中',
    invoiceAmount: 78540.00,
    reconciliationAmount: 78540.00,
    lastStorageTime: '2026-05-01',
    ownerOrg: '天津天地伟业科技有限公司'
  },
  {
    reconciliationNo: 'RC2607030003',
    reconciliationDate: '2026-07-03',
    reconciliationStatus: '已确认',
    invoiceStatus: '已付款',
    invoiceAmount: 188400.00,
    reconciliationAmount: 188400.00,
    lastStorageTime: '2026-05-10',
    ownerOrg: '天津天地伟业数码科技有限公司'
  }
]

const notices = [
  { title: '关于 2026 年 7 月账期对账安排的通知', date: '2026-07-01' },
  { title: '供应商送货单模板更新公告', date: '2026-06-28' },
  { title: '订单回签与发货节点提醒', date: '2026-06-20' }
]

export default {
  orders,
  orderLines,
  orderDirects,
  deliveries,
  receivings,
  reconciliations,
  notices
}

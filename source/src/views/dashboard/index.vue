<template>
  <div class="page-container" data-rpa="dashboard-page">
    <div class="page-header">
      <div>
        <h2 class="page-title">供应商首页</h2>
        <div class="page-desc">订单、发货、收货、对账的 RPA 测试入口。</div>
      </div>
      <el-button type="primary" data-rpa="dashboard-go-orders" @click="$router.push('/supplier/orders')">进入订单列表</el-button>
    </div>

    <div class="dashboard-grid">
      <div v-for="card in cards" :key="card.title" class="dashboard-card">
        <div class="dashboard-card-title">{{ card.title }}</div>
        <div class="dashboard-card-value" :style="{ color: cardColor(card.type) }">{{ card.value }}</div>
      </div>
    </div>

    <div class="dashboard-columns">
      <div>
        <div class="content-card">
          <div class="table-toolbar">
            <div class="toolbar-title">最近订单</div>
            <el-button type="text" @click="$router.push('/supplier/orders')">查看全部</el-button>
          </div>
          <el-table :data="recentOrders" border size="small">
            <el-table-column prop="orderNo" label="订单编号" min-width="150" />
            <el-table-column prop="orderDate" label="日期" width="110" />
            <el-table-column prop="replyStatus" label="回复状态" width="100">
              <template slot-scope="scope"><SupplierStatusTag :status="scope.row.replyStatus" /></template>
            </el-table-column>
            <el-table-column prop="deliveryStatus" label="发货状态" width="110">
              <template slot-scope="scope"><SupplierStatusTag :status="scope.row.deliveryStatus" /></template>
            </el-table-column>
            <el-table-column prop="totalAmount" label="金额" width="110" align="right">
              <template slot-scope="scope"><span class="amount">{{ money(scope.row.totalAmount) }}</span></template>
            </el-table-column>
          </el-table>
        </div>
        <div class="content-card">
          <div class="table-toolbar">
            <div class="toolbar-title">待生成对账收货记录</div>
            <el-button type="text" @click="$router.push('/supplier/receivings')">去处理</el-button>
          </div>
          <el-table :data="pendingReceivings" border size="small">
            <el-table-column prop="orderNo" label="订单编号" min-width="150" />
            <el-table-column prop="receivingNo" label="收货单号" min-width="150" />
            <el-table-column prop="materialName" label="料品名称" min-width="150" />
            <el-table-column prop="payableTotal" label="价税合计" width="120" align="right">
              <template slot-scope="scope"><span class="amount">{{ money(scope.row.payableTotal) }}</span></template>
            </el-table-column>
          </el-table>
        </div>
      </div>

      <div>
        <div class="content-card">
          <div class="toolbar-title" style="margin-bottom:12px;">平台公告</div>
          <el-timeline>
            <el-timeline-item v-for="notice in notices" :key="notice.title" :timestamp="notice.date" placement="top">
              {{ notice.title }}
            </el-timeline-item>
          </el-timeline>
        </div>
        <div class="content-card">
          <div class="toolbar-title" style="margin-bottom:12px;">RPA 测试链路</div>
          <el-steps direction="vertical" :active="1" finish-status="success" style="height: 250px;">
            <el-step title="登录平台" description="admin / 123456 / 8888" />
            <el-step title="查询订单" description="POJS2606030010" />
            <el-step title="下推发货单" description="生成 DN 单据" />
            <el-step title="生成对账单" description="从收货列表进入对账" />
          </el-steps>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { fetchDashboard } from '@/api/supplier'
import SupplierStatusTag from '@/views/supplier/components/SupplierStatusTag'

export default {
  name: 'Dashboard',
  components: { SupplierStatusTag },
  data() {
    return {
      cards: [],
      recentOrders: [],
      pendingReceivings: [],
      notices: []
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    loadData() {
      fetchDashboard().then(res => {
        this.cards = res.data.cards
        this.recentOrders = res.data.recentOrders
        this.pendingReceivings = res.data.pendingReceivings
        this.notices = res.data.notices
      })
    },
    cardColor(type) {
      const map = { primary: '#409EFF', success: '#67C23A', warning: '#E6A23C', danger: '#F56C6C' }
      return map[type] || '#303133'
    },
    money(value) {
      return Number(value || 0).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 })
    }
  }
}
</script>

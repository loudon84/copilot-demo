<template>
  <div class="page-container" data-rpa="order-detail-page">
    <div class="page-header order-detail-header">
      <div>
        <h2 class="page-title">订单详情</h2>
        <div class="page-desc">订单基础信息、供应商信息、物料明细、交付与对账数据。</div>
      </div>
      <div class="header-actions">
        <el-button data-rpa="order-detail-back-btn" @click="goBack">返回列表</el-button>
        <el-button type="primary" data-rpa="order-detail-download-btn" @click="showDownload('orderExport')">下载订单</el-button>
        <el-button type="success" data-rpa="order-detail-push-delivery-btn" :disabled="!order" @click="handlePushDelivery">下推发货单</el-button>
      </div>
    </div>

    <el-card v-loading="loading" class="detail-card" shadow="never">
      <div v-if="order" class="order-summary">
        <div class="summary-main">
          <div class="summary-title" :data-rpa="'order-detail-no-' + order.orderNo">{{ order.orderNo }}</div>
          <div class="summary-subtitle">{{ order.materialSummary }}</div>
        </div>
        <div class="summary-tags">
          <SupplierStatusTag :status="order.replyStatus" />
          <SupplierStatusTag :status="order.deliveryStatus" />
        </div>
      </div>

      <el-alert
        v-if="!loading && !order"
        title="未找到订单"
        type="warning"
        show-icon
        :closable="false"
      />
    </el-card>

    <el-card v-if="order" class="detail-card" shadow="never">
      <div slot="header" class="card-header">基础信息</div>
      <el-descriptions :column="3" border size="medium">
        <el-descriptions-item label="订单编号">{{ order.orderNo }}</el-descriptions-item>
        <el-descriptions-item label="订单日期">{{ order.orderDate }}</el-descriptions-item>
        <el-descriptions-item label="订单类型">{{ order.orderType }}</el-descriptions-item>
        <el-descriptions-item label="是否终止">{{ order.terminated }}</el-descriptions-item>
        <el-descriptions-item label="回复状态">{{ order.replyStatus }}</el-descriptions-item>
        <el-descriptions-item label="发货状态">{{ order.deliveryStatus }}</el-descriptions-item>
        <el-descriptions-item label="订单金额">{{ money(order.totalAmount) }}</el-descriptions-item>
        <el-descriptions-item label="币种">CNY</el-descriptions-item>
        <el-descriptions-item label="付款条件">月结 60 天</el-descriptions-item>
        <el-descriptions-item label="所属单位" :span="2">{{ order.ownerOrg }}</el-descriptions-item>
        <el-descriptions-item label="物料摘要">{{ order.materialSummary }}</el-descriptions-item>
      </el-descriptions>
    </el-card>

    <el-card v-if="order" class="detail-card" shadow="never">
      <div slot="header" class="card-header">供应商与收货信息</div>
      <el-row :gutter="16">
        <el-col :span="12">
          <el-descriptions :column="1" border size="medium">
            <el-descriptions-item label="供应商编码">SUP-TDWY-001</el-descriptions-item>
            <el-descriptions-item label="供应商名称">天津某某电子科技有限公司</el-descriptions-item>
            <el-descriptions-item label="联系人">王经理</el-descriptions-item>
            <el-descriptions-item label="联系电话">13800008888</el-descriptions-item>
          </el-descriptions>
        </el-col>
        <el-col :span="12">
          <el-descriptions :column="1" border size="medium">
            <el-descriptions-item label="收货组织">{{ order.ownerOrg }}</el-descriptions-item>
            <el-descriptions-item label="收货地址">天津市滨海高新区海泰发展六道 6 号</el-descriptions-item>
            <el-descriptions-item label="收货联系人">张工</el-descriptions-item>
            <el-descriptions-item label="要求交期">{{ expectedDeliveryDate }}</el-descriptions-item>
          </el-descriptions>
        </el-col>
      </el-row>
    </el-card>

    <el-card v-if="order" class="detail-card" shadow="never">
      <div slot="header" class="card-header table-header">
        <span>订单物料明细</span>
        <el-button size="mini" data-rpa="order-detail-export-lines-btn" @click="showDownload('orderExport')">导出明细</el-button>
      </div>
      <el-table :data="lines" border size="small" row-key="lineNo" data-rpa="order-detail-lines-table">
        <el-table-column prop="lineNo" label="行号" width="70" fixed />
        <el-table-column prop="materialNo" label="料号" min-width="120" />
        <el-table-column prop="materialName" label="料品名称" min-width="170" />
        <el-table-column prop="materialSpec" label="规格型号" min-width="150" />
        <el-table-column prop="unit" label="单位" width="70" />
        <el-table-column prop="orderQty" label="订单数量" width="95" align="right" />
        <el-table-column prop="deliveredQty" label="已发货" width="85" align="right" />
        <el-table-column prop="undeliveredQty" label="未发货" width="85" align="right" />
        <el-table-column prop="unitPrice" label="含税单价" width="105" align="right">
          <template slot-scope="scope">{{ money(scope.row.unitPrice) }}</template>
        </el-table-column>
        <el-table-column prop="taxRate" label="税率" width="70" />
        <el-table-column prop="amount" label="价税合计" width="120" align="right">
          <template slot-scope="scope"><span class="amount">{{ money(scope.row.amount) }}</span></template>
        </el-table-column>
        <el-table-column prop="deliveryDate" label="交货日期" width="110" />
      </el-table>
    </el-card>

    <el-card v-if="order" class="detail-card" shadow="never">
      <div slot="header" class="card-header">RPA 测试锚点</div>
      <el-row :gutter="16">
        <el-col :span="8">
          <div class="anchor-item">
            <div class="anchor-label">页面标识</div>
            <div class="anchor-value">[data-rpa="order-detail-page"]</div>
          </div>
        </el-col>
        <el-col :span="8">
          <div class="anchor-item">
            <div class="anchor-label">订单编号</div>
            <div class="anchor-value">[data-rpa="order-detail-no-{{ order.orderNo }}"]</div>
          </div>
        </el-col>
        <el-col :span="8">
          <div class="anchor-item">
            <div class="anchor-label">下推发货</div>
            <div class="anchor-value">[data-rpa="order-detail-push-delivery-btn"]</div>
          </div>
        </el-col>
      </el-row>
    </el-card>

    <DownloadDialog :visible.sync="downloadVisible" :file-key="downloadKey" />
  </div>
</template>

<script>
import { fetchOrderDetail, pushDelivery } from '@/api/supplier'
import SupplierStatusTag from './components/SupplierStatusTag'
import DownloadDialog from './components/DownloadDialog'

export default {
  name: 'OrderDetail',
  components: { SupplierStatusTag, DownloadDialog },
  data() {
    return {
      loading: false,
      order: null,
      lines: [],
      downloadVisible: false,
      downloadKey: 'orderExport'
    }
  },
  computed: {
    expectedDeliveryDate() {
      if (!this.lines || this.lines.length === 0) return '-'
      return this.lines[0].deliveryDate
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    loadData() {
      const orderNo = this.$route.params.orderNo
      this.loading = true
      fetchOrderDetail(orderNo).then(res => {
        this.order = res.data.order
        this.lines = res.data.lines || []
      }).finally(() => { this.loading = false })
    },
    handlePushDelivery() {
      pushDelivery({ orders: [this.order] }).then(res => {
        this.$message.success(`已生成发货单：${res.data.deliveryNo}`)
        this.$router.push({ path: '/supplier/deliveries', query: { orderNo: this.order.orderNo } })
      })
    },
    showDownload(key) {
      this.downloadKey = key
      this.downloadVisible = true
    },
    goBack() {
      this.$router.push('/supplier/orders')
    },
    money(value) {
      return Number(value || 0).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 })
    }
  }
}
</script>

<style scoped>
.order-detail-header {
  align-items: center;
}
.header-actions {
  display: flex;
  gap: 8px;
}
.detail-card {
  margin-bottom: 16px;
}
.order-summary {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.summary-title {
  font-size: 22px;
  font-weight: 600;
  color: #1f2d3d;
}
.summary-subtitle {
  margin-top: 8px;
  color: #606266;
}
.summary-tags {
  display: flex;
  gap: 8px;
}
.card-header {
  font-weight: 600;
  color: #1f2d3d;
}
.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.amount {
  font-family: Consolas, Monaco, monospace;
  color: #303133;
}
.anchor-item {
  background: #f8fafc;
  border: 1px solid #ebeef5;
  border-radius: 4px;
  padding: 12px;
}
.anchor-label {
  color: #909399;
  margin-bottom: 6px;
}
.anchor-value {
  color: #303133;
  font-family: Consolas, Monaco, monospace;
  font-size: 12px;
}
</style>

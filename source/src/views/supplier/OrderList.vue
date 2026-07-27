<template>
  <div class="page-container" data-rpa="order-list-page">
    <div class="page-header">
      <div>
        <h2 class="page-title">订单列表</h2>
        <div class="page-desc">供应商采购订单查询、回签状态查看、下推发货单和导出。</div>
      </div>
    </div>

    <div class="filter-card">
      <el-form :inline="true" :model="query" label-width="86px">
        <el-form-item label="订单编号">
          <el-input v-model="query.orderNo" data-rpa="order-no-input" clearable placeholder="如 POJS2606030010" style="width: 190px" />
        </el-form-item>
        <el-form-item label="订单类型">
          <el-select v-model="query.orderType" data-rpa="order-type-select" clearable placeholder="全部" style="width: 140px">
            <el-option label="普通订单" value="普通订单" />
            <el-option label="直发订单" value="直发订单" />
          </el-select>
        </el-form-item>
        <el-form-item label="回复状态">
          <el-select v-model="query.replyStatus" data-rpa="reply-status-select" clearable placeholder="全部" style="width: 140px">
            <el-option label="待签章" value="待签章" />
            <el-option label="待回签" value="待回签" />
            <el-option label="已回签" value="已回签" />
            <el-option label="退回" value="退回" />
          </el-select>
        </el-form-item>
        <el-form-item label="发货状态">
          <el-select v-model="query.deliveryStatus" data-rpa="delivery-status-select" clearable placeholder="全部" style="width: 150px">
            <el-option label="未发货" value="未发货" />
            <el-option label="部分发货" value="部分发货" />
            <el-option label="已发货" value="已发货" />
            <el-option label="超期未发货" value="超期未发货" />
          </el-select>
        </el-form-item>
        <el-form-item label="日期范围">
          <el-date-picker v-model="query.dateRange" data-rpa="order-date-range" type="daterange" value-format="yyyy-MM-dd" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" style="width: 250px" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" data-rpa="order-search-btn" @click="handleSearch">查询</el-button>
          <el-button data-rpa="order-reset-btn" @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <div class="table-card">
      <div class="table-toolbar">
        <div class="toolbar-title">订单明细</div>
        <div>
          <el-button type="success" data-rpa="order-push-delivery-btn" :disabled="selectedRows.length === 0" @click="handlePushDelivery">下推发货单</el-button>
          <el-button data-rpa="order-export-btn" @click="showDownload('orderExport')">导出</el-button>
        </div>
      </div>
      <el-table v-loading="loading" :data="list" border size="small" row-key="orderNo" @selection-change="selectedRows = $event">
        <el-table-column type="selection" width="45" />
        <el-table-column prop="orderNo" label="订单编号" min-width="155">
          <template slot-scope="scope"><span :data-rpa="'order-row-' + scope.row.orderNo">{{ scope.row.orderNo }}</span></template>
        </el-table-column>
        <el-table-column prop="orderDate" label="日期" width="105" />
        <el-table-column prop="orderType" label="订单类型" width="100" />
        <el-table-column prop="terminated" label="是否终止" width="90" />
        <el-table-column prop="totalAmount" label="总金额(元)" width="120" align="right">
          <template slot-scope="scope"><span class="amount">{{ money(scope.row.totalAmount) }}</span></template>
        </el-table-column>
        <el-table-column prop="replyStatus" label="回复状态" width="100"><template slot-scope="scope"><SupplierStatusTag :status="scope.row.replyStatus" /></template></el-table-column>
        <el-table-column prop="deliveryStatus" label="发货状态" width="110"><template slot-scope="scope"><SupplierStatusTag :status="scope.row.deliveryStatus" /></template></el-table-column>
        <el-table-column prop="ownerOrg" label="所属单位" min-width="210" />
        <el-table-column label="操作" width="95" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" :data-rpa="'order-detail-' + scope.row.orderNo" @click="openDetail(scope.row)">详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination background layout="total, prev, pager, next" :total="total" :page-size="query.limit" :current-page.sync="query.page" style="margin-top:14px;text-align:right;" @current-change="loadData" />
    </div>

    <DownloadDialog :visible.sync="downloadVisible" :file-key="downloadKey" />
  </div>
</template>

<script>
import { fetchOrders, pushDelivery } from '@/api/supplier'
import SupplierStatusTag from './components/SupplierStatusTag'
import DownloadDialog from './components/DownloadDialog'

export default {
  name: 'OrderList',
  components: { SupplierStatusTag, DownloadDialog },
  data() {
    return {
      loading: false,
      query: { page: 1, limit: 10, orderNo: '', orderType: '', replyStatus: '', deliveryStatus: '', dateRange: [] },
      list: [],
      total: 0,
      selectedRows: [],
      downloadVisible: false,
      downloadKey: 'orderExport'
    }
  },
  created() { this.loadData() },
  methods: {
    loadData() {
      this.loading = true
      fetchOrders(this.query).then(res => {
        this.list = res.data.items
        this.total = res.data.total
      }).finally(() => { this.loading = false })
    },
    handleSearch() { this.query.page = 1; this.loadData() },
    handleReset() {
      this.query = { page: 1, limit: 10, orderNo: '', orderType: '', replyStatus: '', deliveryStatus: '', dateRange: [] }
      this.loadData()
    },
    handlePushDelivery() {
      pushDelivery({ orders: this.selectedRows }).then(res => {
        this.$message.success(`已生成发货单：${res.data.deliveryNo}`)
        this.$router.push({ path: '/supplier/deliveries', query: { orderNo: this.selectedRows[0].orderNo } })
      })
    },
    openDetail(row) {
      const pend = ['待签章', '退回'].includes(row.replyStatus)
      this.$router.push({
        name: pend ? 'SupplierPendOrderDetail' : 'SupplierOrderDetail',
        params: { orderNo: row.orderNo }
      })
    },
    showDownload(key) { this.downloadKey = key; this.downloadVisible = true },
    money(value) { return Number(value || 0).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }
  }
}
</script>

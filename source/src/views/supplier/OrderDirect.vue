<template>
  <div class="page-container" data-rpa="order-direct-page">
    <div class="page-header">
      <div>
        <h2 class="page-title">订单直发</h2>
        <div class="page-desc">模拟直发订单查询、直发客户地址查看和生成发货单。</div>
      </div>
    </div>
    <div class="filter-card">
      <el-form :inline="true" :model="query" label-width="86px">
        <el-form-item label="订单编号"><el-input v-model="query.orderNo" data-rpa="direct-order-no-input" clearable style="width:190px" /></el-form-item>
        <el-form-item label="直发客户"><el-input v-model="query.directCustomer" data-rpa="direct-customer-input" clearable style="width:180px" /></el-form-item>
        <el-form-item label="发货状态">
          <el-select v-model="query.deliveryStatus" data-rpa="direct-delivery-status-select" clearable placeholder="全部" style="width:150px">
            <el-option label="未发货" value="未发货" />
            <el-option label="部分发货" value="部分发货" />
            <el-option label="已发货" value="已发货" />
          </el-select>
        </el-form-item>
        <el-form-item label="日期范围"><el-date-picker v-model="query.dateRange" data-rpa="direct-date-range" type="daterange" value-format="yyyy-MM-dd" range-separator="至" start-placeholder="开始" end-placeholder="结束" style="width:250px" /></el-form-item>
        <el-form-item>
          <el-button type="primary" data-rpa="direct-search-btn" @click="handleSearch">查询</el-button>
          <el-button data-rpa="direct-reset-btn" @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="table-card">
      <div class="table-toolbar"><div class="toolbar-title">直发订单</div><el-button data-rpa="direct-export-btn" @click="showDownload('orderExport')">导出</el-button></div>
      <el-table v-loading="loading" :data="list" border size="small">
        <el-table-column prop="orderNo" label="订单编号" min-width="145"><template slot-scope="scope"><span :data-rpa="'direct-row-' + scope.row.orderNo">{{ scope.row.orderNo }}</span></template></el-table-column>
        <el-table-column prop="orderDate" label="日期" width="105" />
        <el-table-column prop="directCustomer" label="直发客户" min-width="160" />
        <el-table-column prop="deliveryAddress" label="收货地址" min-width="220" show-overflow-tooltip />
        <el-table-column prop="contactName" label="联系人" width="90" />
        <el-table-column prop="contactPhone" label="联系电话" width="130" />
        <el-table-column prop="totalAmount" label="总金额" width="110" align="right"><template slot-scope="scope"><span class="amount">{{ money(scope.row.totalAmount) }}</span></template></el-table-column>
        <el-table-column prop="deliveryStatus" label="发货状态" width="110"><template slot-scope="scope"><SupplierStatusTag :status="scope.row.deliveryStatus" /></template></el-table-column>
        <el-table-column label="操作" width="130" fixed="right"><template slot-scope="scope"><el-button type="text" :data-rpa="'direct-generate-delivery-' + scope.row.orderNo" @click="generate(scope.row)">生成发货单</el-button></template></el-table-column>
      </el-table>
      <el-pagination background layout="total, prev, pager, next" :total="total" :page-size="query.limit" :current-page.sync="query.page" style="margin-top:14px;text-align:right;" @current-change="loadData" />
    </div>
    <DownloadDialog :visible.sync="downloadVisible" :file-key="downloadKey" />
  </div>
</template>
<script>
import { fetchOrderDirect, pushDelivery } from '@/api/supplier'
import SupplierStatusTag from './components/SupplierStatusTag'
import DownloadDialog from './components/DownloadDialog'
export default {
  name: 'OrderDirect',
  components: { SupplierStatusTag, DownloadDialog },
  data() { return { loading: false, query: { page: 1, limit: 10, orderNo: '', directCustomer: '', deliveryStatus: '', dateRange: [] }, list: [], total: 0, downloadVisible: false, downloadKey: 'orderExport' } },
  created() { this.loadData() },
  methods: {
    loadData() { this.loading = true; fetchOrderDirect(this.query).then(res => { this.list = res.data.items; this.total = res.data.total }).finally(() => { this.loading = false }) },
    handleSearch() { this.query.page = 1; this.loadData() },
    handleReset() { this.query = { page: 1, limit: 10, orderNo: '', directCustomer: '', deliveryStatus: '', dateRange: [] }; this.loadData() },
    generate(row) { pushDelivery({ orders: [row] }).then(res => { this.$message.success(`已生成发货单：${res.data.deliveryNo}`); this.$router.push({ path: '/supplier/deliveries', query: { orderNo: row.orderNo } }) }) },
    showDownload(key) { this.downloadKey = key; this.downloadVisible = true },
    money(value) { return Number(value || 0).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }
  }
}
</script>

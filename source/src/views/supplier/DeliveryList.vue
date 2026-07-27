<template>
  <div class="page-container" data-rpa="delivery-list-page">
    <div class="page-header">
      <div>
        <h2 class="page-title">发货单</h2>
        <div class="page-desc">由订单下推生成的发货单，支持查询、打印送货单和模拟下载。</div>
      </div>
    </div>
    <div class="filter-card">
      <el-form :inline="true" :model="query" label-width="86px">
        <el-form-item label="发货单号"><el-input v-model="query.deliveryNo" data-rpa="delivery-no-input" clearable placeholder="DN2606030010" style="width:170px" /></el-form-item>
        <el-form-item label="订单编号"><el-input v-model="query.orderNo" data-rpa="delivery-order-no-input" clearable placeholder="POJS2606030010" style="width:180px" /></el-form-item>
        <el-form-item label="发货状态">
          <el-select v-model="query.deliveryStatus" data-rpa="delivery-status-list-select" clearable placeholder="全部" style="width:140px">
            <el-option label="待发货" value="待发货" />
            <el-option label="已发货" value="已发货" />
          </el-select>
        </el-form-item>
        <el-form-item label="日期范围"><el-date-picker v-model="query.dateRange" data-rpa="delivery-date-range" type="daterange" value-format="yyyy-MM-dd" range-separator="至" start-placeholder="开始" end-placeholder="结束" style="width:250px" /></el-form-item>
        <el-form-item><el-button type="primary" data-rpa="delivery-search-btn" @click="handleSearch">查询</el-button><el-button data-rpa="delivery-reset-btn" @click="handleReset">重置</el-button></el-form-item>
      </el-form>
    </div>
    <div class="table-card">
      <div class="table-toolbar"><div class="toolbar-title">发货单列表</div><div><el-button data-rpa="delivery-export-btn" @click="showDownload('deliveryNote')">导出</el-button><el-button type="primary" data-rpa="delivery-print-btn" @click="showDownload('deliveryNote')">打印送货单</el-button></div></div>
      <el-table v-loading="loading" :data="list" border size="small">
        <el-table-column prop="deliveryNo" label="发货单号" min-width="150"><template slot-scope="scope"><span :data-rpa="'delivery-row-' + scope.row.deliveryNo">{{ scope.row.deliveryNo }}</span></template></el-table-column>
        <el-table-column prop="orderNo" label="订单编号" min-width="150" />
        <el-table-column prop="deliveryDate" label="发货日期" width="105" />
        <el-table-column prop="deliveryQty" label="发货数量" width="95" align="right" />
        <el-table-column prop="boxCount" label="箱数" width="80" align="right" />
        <el-table-column prop="logisticsCompany" label="物流公司" width="110" />
        <el-table-column prop="trackingNo" label="运单号" min-width="140" />
        <el-table-column prop="deliveryStatus" label="发货状态" width="100"><template slot-scope="scope"><SupplierStatusTag :status="scope.row.deliveryStatus" /></template></el-table-column>
        <el-table-column prop="ownerOrg" label="所属单位" min-width="210" />
        <el-table-column label="操作" width="120" fixed="right"><template slot-scope="scope"><el-button type="text" :data-rpa="'delivery-download-' + scope.row.deliveryNo" @click="showDownload('deliveryNote')">下载送货单</el-button></template></el-table-column>
      </el-table>
      <el-pagination background layout="total, prev, pager, next" :total="total" :page-size="query.limit" :current-page.sync="query.page" style="margin-top:14px;text-align:right;" @current-change="loadData" />
    </div>
    <DownloadDialog :visible.sync="downloadVisible" :file-key="downloadKey" />
  </div>
</template>
<script>
import { fetchDeliveries } from '@/api/supplier'
import SupplierStatusTag from './components/SupplierStatusTag'
import DownloadDialog from './components/DownloadDialog'
export default {
  name: 'DeliveryList',
  components: { SupplierStatusTag, DownloadDialog },
  data() { return { loading: false, query: { page: 1, limit: 10, deliveryNo: '', orderNo: this.$route.query.orderNo || '', deliveryStatus: '', dateRange: [] }, list: [], total: 0, downloadVisible: false, downloadKey: 'deliveryNote' } },
  watch: { '$route.query.orderNo'(value) { this.query.orderNo = value || ''; this.handleSearch() } },
  created() { this.loadData() },
  methods: {
    loadData() { this.loading = true; fetchDeliveries(this.query).then(res => { this.list = res.data.items; this.total = res.data.total }).finally(() => { this.loading = false }) },
    handleSearch() { this.query.page = 1; this.loadData() },
    handleReset() { this.query = { page: 1, limit: 10, deliveryNo: '', orderNo: '', deliveryStatus: '', dateRange: [] }; this.loadData() },
    showDownload(key) { this.downloadKey = key; this.downloadVisible = true }
  }
}
</script>

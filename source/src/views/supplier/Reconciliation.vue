<template>
  <div class="page-container" data-rpa="reconciliation-page">
    <div class="page-header">
      <div>
        <h2 class="page-title">对账单</h2>
        <div class="page-desc">对账日期、对账状态、发票状态和收货应付处理。</div>
      </div>
    </div>
    <div class="filter-card">
      <el-form :inline="true" :model="query" label-width="86px">
        <el-form-item label="对账单号"><el-input v-model="query.reconciliationNo" data-rpa="reconciliation-no-input" clearable style="width:170px" /></el-form-item>
        <el-form-item label="对账日期"><el-date-picker v-model="query.dateRange" data-rpa="reconciliation-date-range" type="daterange" value-format="yyyy-MM-dd" range-separator="至" start-placeholder="开始" end-placeholder="结束" style="width:250px" /></el-form-item>
        <el-form-item label="对账状态">
          <el-select v-model="query.reconciliationStatus" data-rpa="reconciliation-status-select" clearable placeholder="全部" style="width:130px">
            <el-option label="未提交" value="未提交" />
            <el-option label="已提交" value="已提交" />
            <el-option label="已确认" value="已确认" />
          </el-select>
        </el-form-item>
        <el-form-item label="发票状态">
          <el-select v-model="query.invoiceStatus" data-rpa="invoice-status-select" clearable placeholder="全部" style="width:130px">
            <el-option label="未上传" value="未上传" />
            <el-option label="审核中" value="审核中" />
            <el-option label="已付款" value="已付款" />
            <el-option label="退回" value="退回" />
          </el-select>
        </el-form-item>
        <el-form-item><el-button type="primary" data-rpa="reconciliation-search-btn" @click="handleSearch">查询</el-button><el-button data-rpa="reconciliation-reset-btn" @click="handleReset">重置</el-button></el-form-item>
      </el-form>
    </div>
    <div class="table-card">
      <div class="table-toolbar"><div class="toolbar-title">对账单列表</div><el-button data-rpa="reconciliation-export-btn" @click="showDownload('reconciliationExport')">导出</el-button></div>
      <el-table v-loading="loading" :data="list" border size="small">
        <el-table-column prop="reconciliationNo" label="对账单号" min-width="145"><template slot-scope="scope"><span :data-rpa="'reconciliation-row-' + scope.row.reconciliationNo">{{ scope.row.reconciliationNo }}</span></template></el-table-column>
        <el-table-column prop="reconciliationDate" label="对账日期" width="105" />
        <el-table-column prop="reconciliationStatus" label="对账状态" width="100"><template slot-scope="scope"><SupplierStatusTag :status="scope.row.reconciliationStatus" /></template></el-table-column>
        <el-table-column prop="invoiceStatus" label="发票状态" width="100"><template slot-scope="scope"><SupplierStatusTag :status="scope.row.invoiceStatus" /></template></el-table-column>
        <el-table-column prop="invoiceAmount" label="发票总额(元)" width="130" align="right"><template slot-scope="scope"><span class="amount">{{ money(scope.row.invoiceAmount) }}</span></template></el-table-column>
        <el-table-column prop="reconciliationAmount" label="对账总额(元)" width="130" align="right"><template slot-scope="scope"><span class="amount">{{ money(scope.row.reconciliationAmount) }}</span></template></el-table-column>
        <el-table-column prop="lastStorageTime" label="最后入库时间" width="115" />
        <el-table-column prop="ownerOrg" label="所属单位" min-width="210" />
        <el-table-column label="操作" width="160" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" :data-rpa="'reconciliation-payable-' + scope.row.reconciliationNo" @click="openPayable(scope.row)">收货应付</el-button>
            <el-button type="text" :data-rpa="'reconciliation-cancel-' + scope.row.reconciliationNo" @click="cancelRow(scope.row)">取消对账</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination background layout="total, prev, pager, next" :total="total" :page-size="query.limit" :current-page.sync="query.page" style="margin-top:14px;text-align:right;" @current-change="loadData" />
    </div>

    <el-dialog :visible.sync="payableVisible" title="收货应付" width="620px">
      <div v-if="current" data-rpa="payable-dialog">
        <el-alert type="success" show-icon :closable="false" title="该弹窗用于模拟 RPA 点击对账单后查看应付明细。" />
        <el-table :data="payableRows" border size="small" style="margin-top:14px;">
          <el-table-column prop="name" label="项目" />
          <el-table-column prop="value" label="金额" align="right" />
        </el-table>
      </div>
      <div slot="footer">
        <el-button @click="payableVisible = false">关闭</el-button>
        <el-button type="primary" data-rpa="payable-download-btn" @click="showDownload('reconciliationExport')">下载对账文件</el-button>
      </div>
    </el-dialog>
    <DownloadDialog :visible.sync="downloadVisible" :file-key="downloadKey" />
  </div>
</template>
<script>
import { fetchReconciliations } from '@/api/supplier'
import SupplierStatusTag from './components/SupplierStatusTag'
import DownloadDialog from './components/DownloadDialog'
export default {
  name: 'Reconciliation',
  components: { SupplierStatusTag, DownloadDialog },
  data() {
    return {
      loading: false,
      query: { page: 1, limit: 10, reconciliationNo: this.$route.query.reconciliationNo || '', reconciliationStatus: '', invoiceStatus: '', dateRange: [] },
      list: [],
      total: 0,
      payableVisible: false,
      current: null,
      downloadVisible: false,
      downloadKey: 'reconciliationExport'
    }
  },
  computed: {
    payableRows() {
      if (!this.current) return []
      return [
        { name: '收货应付金额', value: this.money(this.current.reconciliationAmount) },
        { name: '发票金额', value: this.money(this.current.invoiceAmount) },
        { name: '差异金额', value: this.money(Number(this.current.reconciliationAmount || 0) - Number(this.current.invoiceAmount || 0)) }
      ]
    }
  },
  created() { this.loadData() },
  methods: {
    loadData() { this.loading = true; fetchReconciliations(this.query).then(res => { this.list = res.data.items; this.total = res.data.total }).finally(() => { this.loading = false }) },
    handleSearch() { this.query.page = 1; this.loadData() },
    handleReset() { this.query = { page: 1, limit: 10, reconciliationNo: '', reconciliationStatus: '', invoiceStatus: '', dateRange: [] }; this.loadData() },
    openPayable(row) { this.current = row; this.payableVisible = true },
    cancelRow(row) { this.$message.warning(`已模拟取消对账：${row.reconciliationNo}`) },
    showDownload(key) { this.downloadKey = key; this.downloadVisible = true },
    money(value) { return Number(value || 0).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }
  }
}
</script>

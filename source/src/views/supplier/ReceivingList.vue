<template>
  <div class="page-container" data-rpa="receiving-list-page">
    <div class="page-header">
      <div>
        <h2 class="page-title">收货列表</h2>
        <div class="page-desc">收货入库明细查询，可按订单编号筛选并生成对账单。</div>
      </div>
    </div>
    <div class="filter-card">
      <el-form :inline="true" :model="query" label-width="92px">
        <el-form-item label="订单编号"><el-input v-model="query.orderNo" data-rpa="receiving-order-no-input" clearable placeholder="POJS2604230001" style="width:180px" /></el-form-item>
        <el-form-item label="收货单号"><el-input v-model="query.receivingNo" data-rpa="receiving-no-input" clearable style="width:170px" /></el-form-item>
        <el-form-item label="料号"><el-input v-model="query.materialNo" data-rpa="material-no-input" clearable style="width:130px" /></el-form-item>
        <el-form-item label="料品名称"><el-input v-model="query.materialName" data-rpa="material-name-input" clearable style="width:150px" /></el-form-item>
        <el-form-item label="对账状态">
          <el-select v-model="query.reconciliationStatus" data-rpa="receiving-status-select" clearable placeholder="全部" style="width:130px">
            <el-option label="未提交" value="未提交" />
            <el-option label="已提交" value="已提交" />
          </el-select>
        </el-form-item>
        <el-form-item label="入库确认"><el-date-picker v-model="query.dateRange" data-rpa="receiving-date-range" type="daterange" value-format="yyyy-MM-dd" range-separator="至" start-placeholder="开始" end-placeholder="结束" style="width:240px" /></el-form-item>
        <el-form-item><el-button type="primary" data-rpa="receiving-search-btn" @click="handleSearch">查询</el-button><el-button data-rpa="receiving-reset-btn" @click="handleReset">重置</el-button></el-form-item>
      </el-form>
    </div>
    <div class="table-card">
      <div class="table-toolbar"><div class="toolbar-title">收货明细</div><div><el-button type="success" data-rpa="receiving-generate-reconciliation-btn" :disabled="selectedRows.length === 0" @click="handleGenerate">生成对账单</el-button><el-button data-rpa="receiving-export-btn" @click="showDownload('reconciliationExport')">导出</el-button></div></div>
      <el-table v-loading="loading" :data="list" border size="small" row-key="id" @selection-change="selectedRows = $event">
        <el-table-column type="selection" width="45" />
        <el-table-column prop="orderNo" label="订单编号" min-width="150"><template slot-scope="scope"><span :data-rpa="'receiving-row-' + scope.row.orderNo + '-' + scope.row.receivingLineNo">{{ scope.row.orderNo }}</span></template></el-table-column>
        <el-table-column prop="receivingNo" label="收货单号" min-width="150" />
        <el-table-column prop="receivingLineNo" label="行号" width="70" />
        <el-table-column prop="reconciliationStatus" label="对账状态" width="100"><template slot-scope="scope"><SupplierStatusTag :status="scope.row.reconciliationStatus" /></template></el-table-column>
        <el-table-column prop="documentType" label="单据类型" width="100" />
        <el-table-column prop="confirmedAt" label="入库确认时间" width="115" />
        <el-table-column prop="materialNo" label="料号" width="110" />
        <el-table-column prop="materialName" label="料品名称" min-width="150" />
        <el-table-column prop="materialSpec" label="料品规格" min-width="130" />
        <el-table-column prop="receivedQty" label="实收数量" width="95" align="right" />
        <el-table-column prop="unitPrice" label="单价(元)" width="100" align="right"><template slot-scope="scope">{{ money(scope.row.unitPrice) }}</template></el-table-column>
        <el-table-column prop="netUnitPrice" label="未税单价" width="100" align="right"><template slot-scope="scope">{{ money(scope.row.netUnitPrice) }}</template></el-table-column>
        <el-table-column prop="taxRate" label="税率" width="70" />
        <el-table-column prop="payableNetAmount" label="可立账未税金额" width="135" align="right"><template slot-scope="scope">{{ money(scope.row.payableNetAmount) }}</template></el-table-column>
        <el-table-column prop="payableTaxAmount" label="可立账税额" width="120" align="right"><template slot-scope="scope">{{ money(scope.row.payableTaxAmount) }}</template></el-table-column>
        <el-table-column prop="payableTotal" label="价税合计" width="120" align="right"><template slot-scope="scope"><span class="amount">{{ money(scope.row.payableTotal) }}</span></template></el-table-column>
        <el-table-column prop="documentDate" label="单据日期" width="105" />
        <el-table-column prop="accountQty" label="立账数量" width="95" align="right" />
        <el-table-column prop="actualArrivalDate" label="实际到货日期" width="115" />
      </el-table>
      <el-pagination background layout="total, prev, pager, next" :total="total" :page-size="query.limit" :current-page.sync="query.page" style="margin-top:14px;text-align:right;" @current-change="loadData" />
    </div>
    <DownloadDialog :visible.sync="downloadVisible" :file-key="downloadKey" />
  </div>
</template>
<script>
import { fetchReceivings, generateReconciliation } from '@/api/supplier'
import SupplierStatusTag from './components/SupplierStatusTag'
import DownloadDialog from './components/DownloadDialog'
export default {
  name: 'ReceivingList',
  components: { SupplierStatusTag, DownloadDialog },
  data() { return { loading: false, query: { page: 1, limit: 10, orderNo: 'POJS2604230001', receivingNo: '', materialNo: '', materialName: '', reconciliationStatus: '未提交', dateRange: [] }, list: [], total: 0, selectedRows: [], downloadVisible: false, downloadKey: 'reconciliationExport' } },
  created() { this.loadData() },
  methods: {
    loadData() { this.loading = true; fetchReceivings(this.query).then(res => { this.list = res.data.items; this.total = res.data.total }).finally(() => { this.loading = false }) },
    handleSearch() { this.query.page = 1; this.loadData() },
    handleReset() { this.query = { page: 1, limit: 10, orderNo: '', receivingNo: '', materialNo: '', materialName: '', reconciliationStatus: '', dateRange: [] }; this.loadData() },
    handleGenerate() { generateReconciliation({ receivings: this.selectedRows }).then(res => { this.$message.success(`已生成对账单：${res.data.reconciliationNo}`); this.$router.push({ path: '/finance/reconciliation', query: { reconciliationNo: res.data.reconciliationNo } }) }) },
    showDownload(key) { this.downloadKey = key; this.downloadVisible = true },
    money(value) { return Number(value || 0).toLocaleString('zh-CN', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }
  }
}
</script>

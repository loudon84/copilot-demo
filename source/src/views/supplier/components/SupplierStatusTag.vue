<template>
  <el-tag :type="tagType" size="mini" effect="plain">{{ status }}</el-tag>
</template>

<script>
export default {
  name: 'SupplierStatusTag',
  props: {
    status: {
      type: String,
      default: ''
    }
  },
  computed: {
    tagType() {
      if (['已回签', '已发货', '已提交', '已确认', '已付款'].includes(this.status)) return 'success'
      if (['待回签', '待签章', '待发货', '未提交', '未上传', '审核中'].includes(this.status)) return 'warning'
      if (['退回', '超期未发货'].includes(this.status)) return 'danger'
      if (['部分发货'].includes(this.status)) return 'primary'
      return 'info'
    }
  }
}
</script>

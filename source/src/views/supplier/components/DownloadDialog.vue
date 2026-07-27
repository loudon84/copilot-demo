<template>
  <el-dialog :visible.sync="innerVisible" title="模拟下载文件" width="520px" @close="$emit('update:visible', false)">
    <el-alert type="info" show-icon :closable="false" title="文件地址由 src/config/download.js 配置，可替换为你们环境的固定路径。" />
    <el-descriptions :column="1" border style="margin-top:14px;">
      <el-descriptions-item label="文件类型">{{ label }}</el-descriptions-item>
      <el-descriptions-item label="固定地址">{{ url }}</el-descriptions-item>
    </el-descriptions>
    <div slot="footer">
      <el-button @click="innerVisible = false">取消</el-button>
      <el-button type="primary" data-rpa="download-confirm-btn" @click="download">下载</el-button>
    </div>
  </el-dialog>
</template>

<script>
import { DOWNLOAD_FILE_CONFIG } from '@/config/download'
import { getDownloadUrl, downloadConfiguredFile } from '@/utils/download'

export default {
  name: 'DownloadDialog',
  props: {
    visible: Boolean,
    fileKey: {
      type: String,
      default: 'orderExport'
    }
  },
  computed: {
    innerVisible: {
      get() { return this.visible },
      set(value) { this.$emit('update:visible', value) }
    },
    url() {
      return getDownloadUrl(this.fileKey)
    },
    label() {
      const file = DOWNLOAD_FILE_CONFIG.files[this.fileKey]
      return file ? file.label : this.fileKey
    }
  },
  methods: {
    download() {
      downloadConfiguredFile(this.fileKey)
      this.innerVisible = false
    }
  }
}
</script>

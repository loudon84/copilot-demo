<template>
  <div class="navbar">
    <div class="navbar-left">
      <i class="el-icon-s-fold navbar-toggle" @click="toggleSideBar" />
      <span class="navbar-title">{{ title }}</span>
      <el-tag size="mini" type="success" effect="dark" data-rpa="portal-env-tag">Demo 环境</el-tag>
    </div>
    <div class="navbar-menu">
      <span
        v-for="item in navItems"
        :key="item.name"
        class="top-link"
        :class="{ active: isNavActive(item) }"
        @click="goNav(item)"
      >
        {{ item.label }}
      </span>
    </div>
    <div class="navbar-right">
      <el-dropdown trigger="click">
        <span class="user-entry" data-rpa="user-dropdown">
          {{ name || '供应商管理员' }}<i class="el-icon-arrow-down el-icon--right" />
        </span>
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item>账号信息</el-dropdown-item>
          <el-dropdown-item divided @click.native="logout" data-rpa="logout-btn">退出登录</el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  name: 'Navbar',
  data() {
    return {
      navItems: [
        { label: '主页', name: 'Dashboard' },
        { label: '订单', name: 'SupplierOrderList', activeNames: ['SupplierOrderList', 'SupplierOrderDetail', 'SupplierPendOrderDetail'] },
        { label: '对账', name: 'SupplierReceivingList' }
      ]
    }
  },
  computed: {
    ...mapGetters(['name']),
    title() {
      return this.$route.meta && this.$route.meta.title ? this.$route.meta.title : '供应商平台'
    }
  },
  methods: {
    toggleSideBar() {
      this.$store.dispatch('app/toggleSideBar')
    },
    goNav(item) {
      if (this.$route.name !== item.name) {
        this.$router.push({ name: item.name })
      }
    },
    isNavActive(item) {
      const activeNames = item.activeNames || [item.name]
      return activeNames.includes(this.$route.name)
    },
    async logout() {
      await this.$store.dispatch('user/logout')
      this.$router.push(`/login?redirect=${this.$route.fullPath}`)
    }
  }
}
</script>

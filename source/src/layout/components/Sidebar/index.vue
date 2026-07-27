<template>
  <div class="supplier-sidebar">
    <div class="sidebar-logo">
      <div class="logo-mark">SRM</div>
      <div>
        <div class="logo-title">天地伟业</div>
        <div class="logo-subtitle">供应商平台</div>
      </div>
    </div>
    <el-menu
      :default-active="$route.path"
      router
      unique-opened
      class="sidebar-menu"
      background-color="#263445"
      text-color="#bfcbd9"
      active-text-color="#409EFF"
    >
      <template v-for="route in routes">
        <el-menu-item
          v-if="!route.hidden && route.children && route.children.length === 1 && !route.children[0].children"
          :key="route.path + route.children[0].path"
          :index="resolvePath(route.path, route.children[0].path)"
          :data-rpa="menuRpa(resolvePath(route.path, route.children[0].path))"
        >
          <i :class="route.children[0].meta.icon || route.meta.icon || 'el-icon-menu'" />
          <span slot="title">{{ route.children[0].meta.title }}</span>
        </el-menu-item>
        <el-submenu v-else-if="!route.hidden" :key="route.path" :index="route.path">
          <template slot="title">
            <i :class="route.meta.icon || 'el-icon-menu'" />
            <span>{{ route.meta.title }}</span>
          </template>
          <el-menu-item
            v-for="child in visibleChildren(route)"
            :key="child.path"
            :index="resolvePath(route.path, child.path)"
            :data-rpa="menuRpa(resolvePath(route.path, child.path))"
          >
            {{ child.meta.title }}
          </el-menu-item>
        </el-submenu>
      </template>
    </el-menu>
    <div class="sidebar-footer">
      <div>RPA 测试 Selector</div>
      <div class="footer-status">data-rpa 已启用</div>
    </div>
  </div>
</template>

<script>
import { constantRoutes } from '@/router'

export default {
  name: 'Sidebar',
  computed: {
    routes() {
      return constantRoutes.filter(route => !route.hidden)
    }
  },
  methods: {
    visibleChildren(route) {
      return (route.children || []).filter(child => !child.hidden)
    },
    resolvePath(basePath, routePath) {
      if (basePath === '/') return `/${routePath}`.replace('//', '/')
      return `${basePath}/${routePath}`.replace('//', '/')
    },
    menuRpa(path) {
      const map = {
        '/dashboard': 'menu-dashboard',
        '/supplier/orders': 'menu-order-list',
        '/supplier/order-direct': 'menu-order-direct',
        '/supplier/deliveries': 'menu-delivery-list',
        '/supplier/receivings': 'menu-receiving-list',
        '/finance/reconciliation': 'menu-reconciliation'
      }
      return map[path] || `menu-${path.replace(/\//g, '-')}`
    }
  }
}
</script>

import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

import Layout from '@/layout'

export const constantRoutes = [
  {
    path: '/login',
    component: () => import('@/views/login/index'),
    hidden: true,
    meta: { title: '登录' }
  },
  {
    path: '/404',
    component: () => import('@/views/error-page/404'),
    hidden: true,
    meta: { title: '404' }
  },
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('@/views/dashboard/index'),
        meta: { title: '供应商首页', icon: 'el-icon-s-home' }
      }
    ]
  },
  {
    path: '/supplier',
    component: Layout,
    redirect: '/supplier/orders',
    name: 'Supplier',
    meta: { title: '订单协同', icon: 'el-icon-s-order' },
    children: [
      {
        path: 'orders',
        name: 'SupplierOrderList',
        component: () => import('@/views/supplier/OrderList'),
        meta: { title: '订单列表' }
      },
      {
        path: 'pend-orders/:orderNo',
        name: 'SupplierPendOrderDetail',
        component: () => import('@/views/supplier/PendOrderDetail'),
        hidden: true,
        meta: { title: '待签章订单详情' }
      },
      {
        path: 'orders/:orderNo',
        name: 'SupplierOrderDetail',
        component: () => import('@/views/supplier/OrderDetail'),
        hidden: true,
        meta: { title: '订单详情' }
      },
      {
        path: 'order-direct',
        name: 'SupplierOrderDirect',
        component: () => import('@/views/supplier/OrderDirect'),
        meta: { title: '订单直发' }
      },
      {
        path: 'deliveries',
        name: 'SupplierDeliveryList',
        component: () => import('@/views/supplier/DeliveryList'),
        meta: { title: '发货单' }
      },
      {
        path: 'receivings',
        name: 'SupplierReceivingList',
        component: () => import('@/views/supplier/ReceivingList'),
        meta: { title: '收货列表' }
      }
    ]
  },
  {
    path: '/finance',
    component: Layout,
    redirect: '/finance/reconciliation',
    name: 'Finance',
    meta: { title: '财务对账', icon: 'el-icon-s-finance' },
    children: [
      {
        path: 'reconciliation',
        name: 'SupplierReconciliation',
        component: () => import('@/views/supplier/Reconciliation'),
        meta: { title: '对账单' }
      }
    ]
  },
  { path: '*', redirect: '/404', hidden: true }
]

const createRouter = () => new Router({
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRoutes
})

const router = createRouter()

export function resetRouter() {
  const newRouter = createRouter()
  router.matcher = newRouter.matcher
}

export default router

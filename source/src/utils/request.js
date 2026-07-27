import axios from 'axios'
import { Message } from 'element-ui'
import store from '@/store'
import { getToken } from '@/utils/auth'

const service = axios.create({
  baseURL: process.env.VUE_APP_BASE_API || '',
  timeout: 10000
})

service.interceptors.request.use(
  config => {
    if (store.getters.token) {
      config.headers['X-Token'] = getToken()
    }
    return config
  },
  error => Promise.reject(error)
)

service.interceptors.response.use(
  response => {
    const res = response.data
    if (res && res.code && res.code !== 20000) {
      Message({ message: res.message || '请求失败', type: 'error', duration: 3000 })
      return Promise.reject(new Error(res.message || '请求失败'))
    }
    return res
  },
  error => {
    Message({ message: error.message, type: 'error', duration: 3000 })
    return Promise.reject(error)
  }
)

export default service

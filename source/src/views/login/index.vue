<template>
  <div class="login-page">
    <div class="login-hero">
      <h1>天地伟业供应商平台</h1>
      <p>面向供应商的订单协同、送货、收货、对账一体化门户。当前版本为 AutoTask / Playwright RPA 测试 Demo，所有业务数据均为 Mock。</p>
      <div class="notice-list">
        <div class="notice-item" v-for="notice in notices" :key="notice.title">
          <i class="el-icon-message-solid" />
          <span>{{ notice.title }}</span>
          <span class="notice-date">{{ notice.date }}</span>
        </div>
      </div>
    </div>
    <div class="login-panel">
      <div class="login-title">供应商登录</div>
      <div class="login-subtitle">演示账号：admin / 123456</div>
      <el-tabs v-model="loginType" stretch>
        <el-tab-pane label="账号登录" name="account" />
        <el-tab-pane label="手机号登录" name="mobile" disabled />
      </el-tabs>
      <el-form ref="loginForm" :model="loginForm" :rules="loginRules" label-position="top" @keyup.enter.native="handleLogin">
        <el-form-item label="账号" prop="username">
          <el-input v-model="loginForm.username" data-rpa="login-username" placeholder="请输入账号" prefix-icon="el-icon-user" />
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input v-model="loginForm.password" data-rpa="login-password" placeholder="请输入密码" show-password prefix-icon="el-icon-lock" />
        </el-form-item>
        <el-form-item label="验证码" prop="captcha">
          <el-row :gutter="10">
            <el-col :span="14">
              <el-input v-model="loginForm.captcha" data-rpa="login-captcha" placeholder="请输入验证码" prefix-icon="el-icon-key" />
            </el-col>
            <el-col :span="10" style="height: 32px!important;">
              <img
                v-if="captchaImageUrl"
                :src="captchaImageUrl"
                alt="验证码"
                class="captcha-image"
                data-rpa="login-captcha-image"
                title="点击刷新验证码"
                @click="refreshCaptcha"
              >
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item>
          <el-checkbox v-model="loginForm.agreement" data-rpa="login-agreement">我已阅读并同意供应商平台使用协议</el-checkbox>
        </el-form-item>
        <el-button :loading="loading" type="primary" style="width:100%;" data-rpa="login-submit" @click="handleLogin">登录</el-button>        
      </el-form>
    </div>
  </div>
</template>

<script>
import { pickRandomVerifyCode } from '@/utils/verify'

export default {
  name: 'Login',
  data() {
    return {
      loginType: 'account',
      loading: false,
      captchaKey: '',
      captchaValue: '',
      captchaImageUrl: '',
      loginForm: {
        username: 'admin',
        password: '123456',
        captcha: '',
        agreement: true
      },
      loginRules: {
        username: [{ required: true, message: '请输入账号', trigger: 'blur' }],
        password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
        captcha: [{ required: true, message: '请输入验证码', trigger: 'blur' }]
      },
      notices: [
        { title: '供应商纳入流程说明', date: '2026-07-01' },
        { title: '订单回签与下推发货单操作指南', date: '2026-06-25' },
        { title: '本月对账窗口已开放', date: '2026-06-20' }
      ]
    }
  },
  created() {
    this.refreshCaptcha()
  },
  methods: {
    refreshCaptcha() {
      const { key, value, imageUrl } = pickRandomVerifyCode(this.captchaKey)
      this.captchaKey = key
      this.captchaValue = value
      this.captchaImageUrl = imageUrl
      this.loginForm.captcha = ''
    },
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (!valid) return
        if (!this.loginForm.agreement) {
          this.$message.warning('请先勾选使用协议')
          return
        }
        if (this.loginForm.captcha.trim().toLowerCase() !== this.captchaValue.toLowerCase()) {
          this.$message.error('验证码错误')
          this.refreshCaptcha()
          return
        }
        this.loading = true
        this.$store.dispatch('user/login', this.loginForm).then(() => {
          this.$router.push({ path: this.$route.query.redirect || '/' })
        }).catch(error => {
          this.$message.error(error.message || error)
          this.refreshCaptcha()
        }).finally(() => {
          this.loading = false
        })
      })
    }
  }
}
</script>

<style scoped>
.captcha-image {
  display: block;
  width: 100%;
  height: autofill;
  object-fit: cover;
  border-radius: 4px;
  cursor: pointer;
  background: #f0f5ff;
}
</style>

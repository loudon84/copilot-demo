const demoUser = {
  token: 'supplier-demo-token',
  name: '供应商管理员',
  avatar: ''
}

function mockResponse(data, delay = 250) {
  return new Promise(resolve => {
    setTimeout(() => resolve({ code: 20000, data }), delay)
  })
}

export function login(data) {
  const { username, password } = data
  if (username === 'admin' && password === '123456') {
    return mockResponse({ token: demoUser.token })
  }
  return Promise.reject(new Error('账号或密码错误。演示账号：admin / 123456'))
}

export function getInfo() {
  return mockResponse({ name: demoUser.name, avatar: demoUser.avatar })
}

export function logout() {
  return mockResponse('success')
}

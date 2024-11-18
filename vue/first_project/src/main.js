import { createApp } from 'vue'
import App from './App.vue'
import router from './router'

createApp(App) // Root Vue 생성
.use(router)   // Vue가 사용하는 보조 기능 추가
.mount('#app') // DOM과 연결되는 코드

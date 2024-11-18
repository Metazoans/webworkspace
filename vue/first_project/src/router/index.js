import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

// 2) 페이지 단위로 호출 @는 src 부터 경로 시작
import DataBinding from '@/views/DataBinding.vue'
import ListBinding from '@/views/ListBinding.vue'
import IfBinding from '@/views/IfBinding.vue'
import OnEvent from '@/views/OnEvent.vue'

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView
  },
  {
    path: '/about',
    name: 'about',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    // 사용자가 요청한 시점에 컴포넌트를 불러옴(딜레이 걸기, 동적) / 03_vue_router.pdf의 특수 주석 문법 참고
    component: () => import(/* webpackChunkName: "about" */ '../views/AboutView.vue') 
  },
  {
    path : '/dataBinding',
    name : 'dataBind',
    component : DataBinding
  },
  {
    path : '/listBinding',
    name : 'listBind',
    component : ListBinding
  },
  {
    path : '/ifBinding',
    name : 'ifBind',
    component : IfBinding
  },
  {
    path : '/onEvent',
    name : 'onEvent',
    component : OnEvent
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

// module.exports = router (노드 방식) -> require() 사용해야함
export default router

import { createRouter, createWebHistory } from 'vue-router'
import MainComponent from '@/views/MainComponent.vue'
import BoardList from '@/views/BoardList.vue'
import BoardInfo from '@/views/BoardInfo.vue'
import BoardAdd from '@/views/BoardAdd.vue'
import BoardUpdate from '@/views/BoardUpdate.vue'


const routes = [
  {
    path: '/',
    name: 'home',
    component: MainComponent
  },
  {
    path: '/boardList',
    name: 'boardList',
    component: BoardList
  },
  {
    path: '/boardInfo',
    name: 'boardInfo',
    component: BoardInfo
  },
  {
    path: '/boardAdd',
    name: 'boardAdd',
    component: BoardAdd
  },
  {
    path: '/boardUpdate/:board_no',
    name: 'boardUpdate',
    component: BoardUpdate
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router

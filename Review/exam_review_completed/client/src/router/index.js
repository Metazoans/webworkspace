import { createRouter, createWebHistory } from 'vue-router'
import BoardList from '../views/BoardList.vue';
import BoardInfo from '../views/BoardInfo.vue';
import BoardForm from '../views/BoardForm.vue';

const routes = [
  {
    path: '/',
    redirect : { name : 'boardList'}
    
  },
  {
    path: '/list',
    name: 'boardList',
    component: BoardList
  },
  {
    path: '/info/:bno',
    name: 'boardInfo',
    component: BoardInfo
  },
  {
    path: '/form',
    name: 'boardForm',
    component: BoardForm
  },

]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router

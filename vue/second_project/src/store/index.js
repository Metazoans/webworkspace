//store.js
// store : vuex가 관리하는 저장소
import { createStore } from 'vuex'
import createPersistedState from 'vuex-persistedstate';

const store = createStore({
  state(){ // vuex에서 관리하는 모든 데이터를 정의
    return {
      cart : [
        {
          product_id : 1,
          product_name : "아이폰 거치대",
          category : "A"
        }
      ],
      count : 0
    }
  }, 
  getters : { // vuex에 저장된 변수 값을 조회하는 경우
    cartCount : (state)=>{
      return state.cart.length;
    }
  },
  mutations : { // 실제 state에 등록된 값을 변경, 단 동기식으로 진행
    increment(state){
      state.count++;
    },
    addProduct(state, info){
      state.cart.push(info);
    }
  },
  actions : { // 동기식으로 진행하는 mutations을 여러개 실행하거나 비동기로 진행
    addProduct(context, info){
      setTimeout(()=>{
        // mutations에 등록된 함수 호출 시 commit 사용
        context.commit('addProduct', info);
      }, 1000);
    }
  },
  plugins :[
    createPersistedState({
      paths : ['cart']
    })
  ]
});

export default store;
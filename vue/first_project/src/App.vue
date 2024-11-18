<template>
  <nav>
    <!-- http://가 절대경로, http 없으면 vue의 라우터를 통해서 연결됨(네이버 접속 안됨) <a href="http://www.naver.com">네이버</a> -->
    <router-link to="/">Home</router-link> |
    <router-link to="/about">About</router-link> |

    <router-link to="/dataBinding">DataBinding</router-link> | <!-- routes의 path로 가져오기 -->
    <router-link v-bind:to="{ name : 'listBind' }">ListBinding</router-link> | <!-- routes의 name 속성으로 가져오기 -->
    <router-link :to="{ path : '/ifBinding' }">IfBinding</router-link> | <!-- bind 디렉티브는 생략 가능 -->
    <router-link to="/onEvent">OnEvent</router-link>
  </nav>
  <h1>모든 페이지에 출력</h1>

  <!-- router-link로 넣은 페이지 출력 -->
  <router-view/>
  
  <hr>

  <!-- 컴포넌트를 tag화 시킴 -->
  <!-- <data-binding></data-binding> -->
  <DataBinding/>  <!-- 원래 <data-binding/> 케밥 표기법으로 작성해야 하지만 vue가 알아서 표기법 변경해줌 -->
</template>


<script>
// 1) 자식 컴포넌트로 등록 => 특정 페이지의 조각을 구성
import DataBinding from './views/DataBinding.vue';

export default {
  components : {
    DataBinding // "data-binding" : DataBinding  =>  자동 표기법 변경 
    
  }
}
</script>


<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

nav {
  padding: 30px;
}

nav a {
  font-weight: bold;
  color: #2c3e50;
}

nav a.router-link-exact-active {
  color: #42b983;
}
</style>

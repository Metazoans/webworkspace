<template>
  <div>
    <input type="text" v-model.lazy="selected">
    <p><span>PropsCom</span>  <span>StoreCom</span>  <span>TextModal</span></p>
    <p>▽ 컴포넌트</p>
    <component v-bind:is="selected"></component>
  </div>
</template>
<script>
import PropsCom from './components/PropsComponent.vue';
import StoreCom from './components/StoreComponent.vue';
import TextModal from './views/TextModal.vue';

export default{
  name: 'app',
  data() {
    return {
      selected : 'TextModal'
    }
  },
  components : {
    PropsCom,
    StoreCom,
    TextModal,
  },
  created(){
    console.log('App.vue Create');
  },
  mounted(){
    console.log('App.vue Mounted');
  },

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
</style>

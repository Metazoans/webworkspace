<template>
  <!-- <img alt="Vue logo" src="./assets/logo.png"> -->
  <!-- <HelloWorld msg="Welcome to Your Vue.js App"/> -->
   <VueComponent/>
</template>

<script>
// import HelloWorld from './components/HelloWorld.vue'
import VueComponent from './components/VueComponent.vue'

export default {
  name: 'App',
  components: {
    // HelloWorld
    VueComponent
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
  margin-top: 60px;
}
</style>

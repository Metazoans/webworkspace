<template>
  <div>
    <input type="text" v-model.lazy="selected">
    <component v-bind:is="selected"></component>
  </div>
</template>
<script>
// App.vue
import PropsCom from "@/components/PropsComponent.vue"
import StoreCom from "./components/StoreComponent.vue";
import TextModal from "./views/TextModal.vue";

export default{
  name : 'app',
  data(){
    return {
      selected : 'TextModal'
    }
  },
  components : {
    PropsCom,
    StoreCom,
    TextModal
  },
  created(){
    console.log('App.vue Created');
  },
  mounted(){
    console.log('App.vue Mounted');
  },
}
</script>
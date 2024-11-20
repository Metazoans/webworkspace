<!-- components/PageTitle.vue -->
<template>
  <h2>{{ title }}</h2>
</template>
<script>
export default {
  /*
  data(){
    return {
      'title' : 'Hello, World!'
    }
  },
  */
  props : ['title'], // 부모가 넘겨준 값들
  created(){
    console.log('PageTitle.vue Created');
  },
  mounted(){
    console.log('PageTitle.vue Mounted');
  },
}
</script>
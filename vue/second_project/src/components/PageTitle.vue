<!-- components/PageTitle.vue -->
<template>
  <h3>{{ titleData }}</h3>
  <p>△자식 데이터</p>
</template>

<script>
export default {
  /*
  data(){
    return {
      titleData : 'Hello, World'
    }
  },
  */
  props: ['titleData'],     // 부모가 넘겨준 값들
  created(){
    console.log('PageTitle.vue Create');
  },
  mounted(){
    console.log('PageTitle.vue Mounted');
  },
}
</script>

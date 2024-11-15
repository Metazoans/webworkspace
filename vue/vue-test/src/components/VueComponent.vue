<!-- VueComponent.vue -->

<!-- html -->
<template>
  <!-- 주의! 하나의 태그만 등록(최상위 태그가 1개, 하위는 상관없음) -->
  <div>
    <label><input type="text" v-model="msg"></label>
    <p>{{ msg }}</p>
  </div>
</template>

<!-- javascript -->
<script>
  export default { // module.exports와 같은 의미 == 내보내기
    name : 'VueComponent',
    data() { // == data : function() {}
      return {
        msg : '2024-11-15'
      }
    }
  }
</script>

<!-- css -->
<style>
  p {
    background-color: bisque;
  }
</style>


